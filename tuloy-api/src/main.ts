import 'reflect-metadata';
import { NestFactory } from '@nestjs/core';
import { AppModule, setupApp } from './app.module';

async function bootstrap() {
  try {
    process.loadEnvFile(); // .env in the working directory, if present
  } catch {}
  // rawBody: payment webhooks verify their signature over the exact bytes received.
  const app = setupApp(await NestFactory.create(AppModule, { rawBody: true }));
  await app.listen(Number(process.env.PORT ?? 3000));
}
bootstrap();
