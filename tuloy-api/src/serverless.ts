import 'reflect-metadata';
import { NestFactory } from '@nestjs/core';
import { ExpressAdapter } from '@nestjs/platform-express';
import express from 'express';
import type { Request, Response } from 'express';
import { AppModule, setupApp } from './app.module';

/** Vercel function entry (api/index.js): one Nest app per warm instance, built on the first request. */
const server = express();
let ready: Promise<unknown> | undefined;

export async function handler(req: Request, res: Response) {
  ready ??= NestFactory.create(AppModule, new ExpressAdapter(server), { rawBody: true }).then((app) => setupApp(app).init());
  await ready;
  server(req, res);
}
