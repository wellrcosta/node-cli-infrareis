import { describe, it, expect, beforeAll } from "vitest";
import request from "supertest";
import { app } from "../../../src/app/app";
import type { UserRepo } from "../../../src/repositories/user.repo";
import { getUserRepo } from "../../../src/repositories/user.repo";
import "../setup/db-setup";

let repo: UserRepo;

describe("Users CRUD (integration)", () => {
  beforeAll(async () => {
    repo = getUserRepo();
    if (repo.init) await repo.init();
  });

  it("POST /api/users -> create", async () => {
    const res = await request(app)
      .post("/api/users")
      .send({ name: "Ana", email: "ana@example.com" })
      .expect(201);
    expect(res.body).toMatchObject({ name: "Ana", email: "ana@example.com" });
    expect(res.body).toHaveProperty("id");
  });

  it("GET /api/users -> list", async () => {
    const res = await request(app).get("/api/users").expect(200);
    expect(Array.isArray(res.body)).toBe(true);
  });

  it("GET /api/users/:id -> getById", async () => {
    const created = await request(app)
      .post("/api/users")
      .send({ name: "Bia", email: "bia@example.com" })
      .expect(201);
    const res = await request(app).get(`/api/users/${created.body.id}`).expect(200);
    expect(res.body).toMatchObject({ id: created.body.id, name: "Bia" });
  });

  it("PUT /api/users/:id -> update", async () => {
    const created = await request(app)
      .post("/api/users")
      .send({ name: "Caio", email: "caio@example.com" })
      .expect(201);
    const res = await request(app)
      .put(`/api/users/${created.body.id}`)
      .send({ name: "Caio Silva" })
      .expect(200);
    expect(res.body).toMatchObject({ id: created.body.id, name: "Caio Silva" });
  });

  it("DELETE /api/users/:id -> remove", async () => {
    const created = await request(app)
      .post("/api/users")
      .send({ name: "Dani", email: "dani@example.com" })
      .expect(201);
    await request(app).delete(`/api/users/${created.body.id}`).expect(204);
    await request(app).get(`/api/users/${created.body.id}`).expect(404);
  });
});
