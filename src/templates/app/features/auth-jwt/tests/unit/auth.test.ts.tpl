import { describe, it, expect } from "vitest";
import request from "supertest";
import express from "express";
import { signToken } from "../../src/auth/jwt";
import { authenticateJwt } from "../../src/middlewares/auth";

process.env.JWT_SECRET = "test-secret";
process.env.JWT_EXPIRES_IN = "1h";

describe("auth-jwt middleware", () => {
  it("blocks request without token", async () => {
    const app = express();
    app.get("/secure", authenticateJwt, (_req, res) => res.json({ ok: true }));
    const res = await request(app).get("/secure").expect(401);
    expect(res.body).toHaveProperty("error");
  });

  it("allows request with valid token", async () => {
    const app = express();
    app.get("/secure", authenticateJwt, (req, res) => res.json({ user: req.user }));
    const token = signToken({ id: "u1", role: "admin" });
    const res = await request(app).get("/secure").set("Authorization", `Bearer ${token}`).expect(200);
    expect(res.body.user).toMatchObject({ id: "u1", role: "admin" });
  });
});
