/**
 * Runs against a real Postgres (DATABASE_URL) with the schema applied.
 * Covers the Phase 1 security paths: refresh rotation + reuse detection, RBAC, audit, error shape.
 */
import { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import { randomUUID } from 'node:crypto';
import request from 'supertest';
import { AppModule, setupApp } from '../src/app.module';
import { PrismaService } from '../src/common/prisma.service';

describe('auth + RBAC', () => {
  let app: INestApplication;
  let prisma: PrismaService;
  let hotelId: string;
  const login = `t-${randomUUID()}@tuloy.test`;
  const password = 'Sup3rSecret!';

  beforeAll(async () => {
    try {
      process.loadEnvFile();
    } catch {}
    process.env.JWT_SECRET ??= 'test-secret-not-for-prod';
    process.env.JOBS = 'off';
    const mod = await Test.createTestingModule({ imports: [AppModule] }).compile();
    app = setupApp(mod.createNestApplication({ rawBody: true }));
    await app.init();
    prisma = app.get(PrismaService);
    hotelId = (await prisma.hotel.create({ data: { name: 'Test Hotel' } })).id;
  });

  afterAll(() => app.close());

  const http = () => request(app.getHttpServer());

  it('register → refresh rotates → replaying an old token kills the session', async () => {
    const reg = await http().post('/v1/auth/register').send({ fullName: 'T', login, password, hotelId }).expect(201);
    expect(reg.body.user.memberships[0]).toMatchObject({ hotelId, role: 'GUEST' });
    expect(reg.body.user.passwordHash).toBeUndefined();

    const r1 = reg.body.refreshToken;
    const rot = await http().post('/v1/auth/refresh').send({ refreshToken: r1 }).expect(200);
    const r2 = rot.body.refreshToken;
    expect(r2).not.toBe(r1);

    await http().post('/v1/auth/refresh').send({ refreshToken: r1 }).expect(401); // reuse
    await http().post('/v1/auth/refresh').send({ refreshToken: r2 }).expect(401); // family revoked
  });

  it('wrong password gives a localized, stable error', async () => {
    const res = await http()
      .post('/v1/auth/login')
      .set('Accept-Language', 'fil-PH,fil;q=0.9')
      .send({ login, password: 'nope-nope' })
      .expect(401);
    expect(res.body.error).toEqual({ code: 'INVALID_CREDENTIALS', message: 'Mali ang email/phone o password.' });
  });

  it('guest cannot change hotel settings; admin can and it is audited', async () => {
    const { body } = await http().post('/v1/auth/login').send({ login, password }).expect(200);
    const auth = { Authorization: `Bearer ${body.accessToken}` };
    await http().patch(`/v1/admin/hotels/${hotelId}`).set(auth).send({ name: 'Hacked' }).expect(403);
    await http().get('/v1/me').expect(401);

    await prisma.membership.update({
      where: { userId_hotelId: { userId: body.user.id, hotelId } },
      data: { role: 'ADMIN' },
    });
    const res = await http().patch(`/v1/admin/hotels/${hotelId}`).set(auth).send({ name: 'Renamed' }).expect(200);
    expect(res.body.name).toBe('Renamed');
    const log = await prisma.auditLog.findFirst({ where: { entityId: hotelId, action: 'hotel.update' } });
    expect(log?.actorId).toBe(body.user.id);
  });
});
