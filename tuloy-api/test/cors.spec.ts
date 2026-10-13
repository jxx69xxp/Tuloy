/** No database needed: a stub controller is mounted behind the real setupApp pipeline. */
import { Controller, Get, INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import request from 'supertest';
import { setupApp } from '../src/app.module';

@Controller('hotels')
class PingController {
  @Get(':id')
  get() {
    return { ok: true };
  }
}

const HOTEL = '/v1/hotels/6f1d2c0e-8b1a-4a43-9d57-2c3b1a0f9e11';

describe('CORS allowlist', () => {
  let app: INestApplication;
  const saved = { cors: process.env.CORS_ORIGINS, env: process.env.NODE_ENV };

  beforeAll(async () => {
    const mod = await Test.createTestingModule({ controllers: [PingController] }).compile();
    app = setupApp(mod.createNestApplication());
    await app.init();
  });
  afterAll(async () => {
    await app.close();
    restore();
  });
  afterEach(restore);

  function restore() {
    if (saved.cors === undefined) delete process.env.CORS_ORIGINS;
    else process.env.CORS_ORIGINS = saved.cors;
    if (saved.env === undefined) delete process.env.NODE_ENV;
    else process.env.NODE_ENV = saved.env;
  }

  describe('with CORS_ORIGINS set', () => {
    beforeEach(() => {
      process.env.CORS_ORIGINS = 'https://admin.example.com';
    });

    it('allows a listed origin', async () => {
      const res = await request(app.getHttpServer()).get(HOTEL).set('Origin', 'https://admin.example.com');
      expect(res.status).toBe(200);
      expect(res.headers['access-control-allow-origin']).toBe('https://admin.example.com');
    });

    it('does not allow an unlisted origin', async () => {
      const res = await request(app.getHttpServer()).get(HOTEL).set('Origin', 'https://evil.example.com');
      expect(res.headers['access-control-allow-origin']).toBeUndefined();
    });

    it('does not block requests without an Origin', async () => {
      const res = await request(app.getHttpServer()).get(HOTEL);
      expect(res.status).toBe(200);
      expect(res.headers['access-control-allow-origin']).toBeUndefined();
    });

    it('answers preflight with the custom headers', async () => {
      const res = await request(app.getHttpServer())
        .options(HOTEL)
        .set('Origin', 'https://admin.example.com')
        .set('Access-Control-Request-Method', 'POST')
        .set('Access-Control-Request-Headers', 'authorization,idempotency-key,content-type');
      expect(res.headers['access-control-allow-origin']).toBe('https://admin.example.com');
      expect(res.headers['access-control-allow-headers'].toLowerCase()).toContain('idempotency-key');
    });

    it('answers preflight for the headers the app sends on every request', async () => {
      const res = await request(app.getHttpServer())
        .options(HOTEL)
        .set('Origin', 'https://admin.example.com')
        .set('Access-Control-Request-Method', 'POST')
        .set('Access-Control-Request-Headers', 'x-hotel-id,accept-language');
      expect(res.headers['access-control-allow-origin']).toBe('https://admin.example.com');
      const allowed = res.headers['access-control-allow-headers'].toLowerCase();
      expect(allowed).toContain('x-hotel-id');
      expect(allowed).toContain('accept-language');
    });

    it('gives no allow-origin to a preflight from an unlisted origin', async () => {
      const res = await request(app.getHttpServer())
        .options(HOTEL)
        .set('Origin', 'https://evil.example.com')
        .set('Access-Control-Request-Method', 'POST')
        .set('Access-Control-Request-Headers', 'x-hotel-id');
      expect(res.headers['access-control-allow-origin']).toBeUndefined();
    });
  });

  describe('with CORS_ORIGINS unset', () => {
    beforeEach(() => {
      delete process.env.CORS_ORIGINS;
    });

    it('allows localhost in non-production', async () => {
      process.env.NODE_ENV = 'test';
      const res = await request(app.getHttpServer()).get(HOTEL).set('Origin', 'http://localhost:51234');
      expect(res.headers['access-control-allow-origin']).toBe('http://localhost:51234');
    });

    it('allows 127.0.0.1 in non-production', async () => {
      process.env.NODE_ENV = 'test';
      const res = await request(app.getHttpServer()).get(HOTEL).set('Origin', 'http://127.0.0.1:8080');
      expect(res.headers['access-control-allow-origin']).toBe('http://127.0.0.1:8080');
    });

    it('does not allow a localhost lookalike origin', async () => {
      process.env.NODE_ENV = 'test';
      const res = await request(app.getHttpServer()).get(HOTEL).set('Origin', 'http://localhost.evil.com');
      expect(res.headers['access-control-allow-origin']).toBeUndefined();
    });

    it('allows nothing in production', async () => {
      process.env.NODE_ENV = 'production';
      const res = await request(app.getHttpServer()).get(HOTEL).set('Origin', 'http://localhost:51234');
      expect(res.headers['access-control-allow-origin']).toBeUndefined();
    });
  });
});
