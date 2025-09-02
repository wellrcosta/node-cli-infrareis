import { describe, it, expect } from "vitest";
import request from "supertest";
import { app } from "../../../src/app/app";

describe("Swagger", () => {
  it("GET /docs.json -> retorna o spec", async () => {
    const res = await request(app).get("/docs.json").expect(200);
    expect(res.body).toHaveProperty("openapi");
    expect(res.body).toHaveProperty("paths");
  });
});
