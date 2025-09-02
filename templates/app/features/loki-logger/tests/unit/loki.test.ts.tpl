import { describe, it, expect } from "vitest";

describe("loki-logger", () => {
  it("creates logger without LOKI_URL", async () => {
    delete process.env.LOKI_URL;
    const { logger } = await import("../../src/utils/logger");
    expect(typeof logger.info).toBe("function");
  });

  it("creates logger with LOKI_URL (no throw)", async () => {
    process.env.LOKI_URL = "http://localhost:3100";
    process.env.LOKI_LABELS = '{"service":"test","env":"test"}';
    const { logger } = await import("../../src/utils/logger");
    logger.info("hello loki"); // não deve lançar
    expect(true).toBe(true);
  });
});
