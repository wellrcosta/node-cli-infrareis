import request from "supertest";
import { app } from "../../src/app/app";
import { describe, it, expect } from "vitest";

describe("Minimal API", () => {
  it("GET /health -> 200 { status: ok }", async () => {
    const res = await request(app).get("/health").expect(200);
    expect(res.body).toHaveProperty("status", "ok");
    expect(res.body).toHaveProperty("timestamp");
  });

  it("GET / -> 200 { message }", async () => {
    const res = await request(app).get("/").expect(200);
    expect(res.body).toHaveProperty("message");
    expect(typeof res.body.message).toBe("string");
  });
});
