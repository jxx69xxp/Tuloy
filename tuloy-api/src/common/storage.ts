import { createHash, createHmac, randomUUID } from 'node:crypto';

// S3-compatible object storage via presigned URLs: the app uploads straight to the bucket,
// the API never handles file bytes. Works with AWS S3, Cloudflare R2, Supabase Storage (S3 API) and MinIO.
// No SDK: AWS Signature V4 query signing is ~30 lines of stdlib crypto.

const rfc3986 = (s: string) => encodeURIComponent(s).replace(/[!'()*]/g, (c) => `%${c.charCodeAt(0).toString(16).toUpperCase()}`);
const sha256hex = (s: string) => createHash('sha256').update(s).digest('hex');
const hmac = (k: Buffer | string, s: string) => createHmac('sha256', k).update(s).digest();

/** SigV4 query-string signature (exported for the known-answer test). */
export function signV4Query(i: {
  method: string;
  host: string;
  path: string; // already URI-encoded
  region: string;
  accessKey: string;
  secretKey: string;
  expires: number;
  now: Date;
}) {
  const amzDate = i.now.toISOString().replace(/[-:]/g, '').replace(/\.\d{3}/, ''); // 20130524T000000Z
  const date = amzDate.slice(0, 8);
  const scope = `${date}/${i.region}/s3/aws4_request`;
  const params: Record<string, string> = {
    'X-Amz-Algorithm': 'AWS4-HMAC-SHA256',
    'X-Amz-Credential': `${i.accessKey}/${scope}`,
    'X-Amz-Date': amzDate,
    'X-Amz-Expires': String(i.expires),
    'X-Amz-SignedHeaders': 'host',
  };
  const query = Object.keys(params)
    .sort()
    .map((k) => `${rfc3986(k)}=${rfc3986(params[k])}`)
    .join('&');
  const canonical = [i.method, i.path, query, `host:${i.host}`, '', 'host', 'UNSIGNED-PAYLOAD'].join('\n');
  const toSign = ['AWS4-HMAC-SHA256', amzDate, scope, sha256hex(canonical)].join('\n');
  const key = hmac(hmac(hmac(hmac(`AWS4${i.secretKey}`, date), i.region), 's3'), 'aws4_request');
  return `${query}&X-Amz-Signature=${createHmac('sha256', key).update(toSign).digest('hex')}`;
}

const env = () => {
  const { S3_ENDPOINT, S3_BUCKET, S3_ACCESS_KEY, S3_SECRET_KEY } = process.env;
  if (!S3_ENDPOINT || !S3_BUCKET || !S3_ACCESS_KEY || !S3_SECRET_KEY) throw new Error('Set S3_ENDPOINT, S3_BUCKET, S3_ACCESS_KEY, S3_SECRET_KEY');
  return { endpoint: new URL(S3_ENDPOINT), bucket: S3_BUCKET, accessKey: S3_ACCESS_KEY, secretKey: S3_SECRET_KEY, region: process.env.S3_REGION ?? 'us-east-1' };
};

/** Presigned PUT (path-style URL), valid 15 minutes. Returns the object key to store in the DB. */
export function presignUpload(folder: string, ext: string) {
  const e = env();
  const key = `${folder}/${randomUUID()}.${ext}`;
  const path = `/${e.bucket}/${key.split('/').map(rfc3986).join('/')}`;
  const qs = signV4Query({ method: 'PUT', host: e.endpoint.host, path, region: e.region, accessKey: e.accessKey, secretKey: e.secretKey, expires: 900, now: new Date() });
  return { key, uploadUrl: `${e.endpoint.origin}${path}?${qs}`, url: assetUrl(key) };
}

/** Public URL for a stored key (bucket must allow public read, or put a CDN in front). */
export function assetUrl(key: string) {
  if (/^https?:\/\//.test(key)) return key;
  const base = process.env.ASSET_BASE_URL ?? `${process.env.S3_ENDPOINT ?? ''}/${process.env.S3_BUCKET ?? ''}`;
  return `${base.replace(/\/$/, '')}/${key}`;
}
