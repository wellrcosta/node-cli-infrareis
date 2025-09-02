import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";

// Mock do ioredis para não exigir Redis real
vi.mock("ioredis", async () => {
  const mod = await vi.importActual<any>("ioredis-mock");
  return { default: mod.default || mod };
});

import { cacheGet, cacheSet, cacheDel, withCache, __redisReset } from "../../src/cache/redis";

describe("redis helpers (mocked)", () => {
  beforeEach(async () => {
    process.env.REDIS_URL = "redis://localhost:6379";
    await __redisReset();
  });
  afterEach(async () => {
    await __redisReset();
    delete process.env.REDIS_URL;
    delete process.env.REDIS_DEFAULT_TTL;
  });

  it("set/get works", async () => {
    await cacheSet("k1", { a: 1 }, 60);
    const v = await cacheGet<{ a: number }>("k1");
    expect(v).toEqual({ a: 1 });
  });

  it("del works", async () => {
    await cacheSet("k2", "x", 10);
    await cacheDel("k2");
    const v = await cacheGet("k2");
    expect(v).toBeNull();
  });

  it("withCache caches producer result", async () => {
    let calls = 0;
    const value1 = await withCache({ key: "k3", ttl: 5 }, async () => {
      calls++; return { n: 42 };
    });
    const value2 = await withCache({ key: "k3", ttl: 5 }, async () => {
      calls++; return { n: 99 };
    });
    expect(calls).toBe(1);
    expect(value1).toEqual({ n: 42 });
    expect(value2).toEqual({ n: 42 });
  });

  it("no-op when REDIS_URL is missing", async () => {
    delete process.env.REDIS_URL;
    await __redisReset();
    await cacheSet("k4", "x", 10);
    const v = await cacheGet("k4");
    expect(v).toBeNull(); // sem erro, apenas não cacheia
  });
});
