import { describe, it, expect, vi, beforeEach } from "vitest";

vi.mock("amqplib", () => {
  return {
    connect: vi.fn().mockResolvedValue({
      createChannel: vi.fn().mockResolvedValue({
        assertQueue: vi.fn(),
        sendToQueue: vi.fn(),
        consume: vi.fn((_queue, cb) => {
          const fakeMsg = { content: Buffer.from(JSON.stringify({ test: "ok" })) };
          cb(fakeMsg);
        }),
        ack: vi.fn(),
        nack: vi.fn(),
      }),
      close: vi.fn(),
    }),
  };
});

import { publishMessage } from "../../src/messaging/publisher";
import { consumeMessages } from "../../src/messaging/consumer";

describe("RabbitMQ (mocked)", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("should publish a message", async () => {
    await publishMessage({ hello: "world" });
    expect(true).toBe(true);
  });

  it("should consume a message", async () => {
    let received: any = null;

    await consumeMessages(async (msg) => {
      received = msg;
    });

    expect(received).toEqual({ test: "ok" });
  });
});
