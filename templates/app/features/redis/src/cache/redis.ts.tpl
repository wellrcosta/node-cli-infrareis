import type { Redis } from "ioredis";
let client: Redis | null = null;

// Lazy init para não penalizar quem não usa
async function getClient(): Promise<Redis | null> {
  if (client) return client;

  const url = process.env.REDIS_URL;
  if (!url) return null; // modo no-op

  try {
    const { default: IORedis } = await import("ioredis");
    client = new IORedis(url, { lazyConnect: true });
    await client.connect();
    return client;
  } catch (err) {
    // eslint-disable-next-line no-console
    console.warn("[redis] falha ao conectar, operando em modo no-op:", err);
    return null;
  }
}

export async function cacheGet<T = any>(key: string): Promise<T | null> {
  const c = await getClient();
  if (!c) return null;
  const raw = await c.get(key);
  if (!raw) return null;
  try { return JSON.parse(raw) as T; } catch { return null; }
}

export async function cacheSet<T = any>(key: string, value: T, ttlSeconds?: number): Promise<void> {
  const c = await getClient();
  if (!c) return;
  const payload = JSON.stringify(value);
  if (ttlSeconds && ttlSeconds > 0) {
    await c.set(key, payload, "EX", ttlSeconds);
  } else {
    await c.set(key, payload);
  }
}

export async function cacheDel(key: string): Promise<void> {
  const c = await getClient();
  if (!c) return;
  await c.del(key);
}

export async function withCache<T>(
  opts: { key: string; ttl?: number },
  producer: () => Promise<T>
): Promise<T> {
  const found = await cacheGet<T>(opts.key);
  if (found !== null && found !== undefined) return found;
  const data = await producer();
  const ttl = opts.ttl ?? Number(process.env.REDIS_DEFAULT_TTL || 0);
  await cacheSet(opts.key, data, ttl > 0 ? ttl : undefined);
  return data;
}

/** Para testes desligarem o client entre specs */
export async function __redisReset() {
  if (client) {
    try { await client.quit(); } catch {}
  }
  client = null;
}
