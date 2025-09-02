# Boilerplate Generator – CLI

A fast, opinionated project scaffolder for Node.js + TypeScript APIs. It creates a production-ready layout with optional building blocks (databases, messaging, docs, auth, logging, cache), consistent tooling, and working tests out‑of‑the‑box.

---

## ✨ Key Features

* **Presets**: `minimal` (clean Express skeleton) and `crud` (Users CRUD with layered architecture).
* **Databases** (per preset `crud`):

  * **SQLite** via **Prisma** (migrations, dev/test DB separation).
  * **Postgres** via **pg** (tests use **Testcontainers**).
  * **MongoDB** via **Mongoose** (tests use **mongodb-memory-server**).
* **Optional Features (plug & play)**:

  * **RabbitMQ** (publisher/consumer scaffolds; tests mocked).
  * **Swagger (OpenAPI)** from **JSDoc in route files**; served at `/docs` and `/docs.json`.
  * **Auth JWT** (sign/verify + middleware `authenticateJwt`).
  * **Loki Logger** (Winston transport to Grafana Loki; console fallback).
  * **Redis Cache** (ioredis + helpers; tests mocked with ioredis-mock).
* **Testing**: Vitest + Supertest with ready-to-run **integration/unit** tests and **LCOV** coverage.
* **Tooling**: TypeScript, ESLint, Prettier, TSX (watch mode), structured logging, env profiles, CI-ready.
* **Templating**: simple `.tpl` files with variable interpolation and **overlays** (preset/feature/DB layer merges).

---

## 🧭 When to Use

* Kickstart new Node/TS APIs with consistent structure and guards.
* Create CRUD services quickly with a switchable persistence layer.
* Add standardized features (messaging, docs, auth, logging, cache) without vendor lock.

---

## 🚀 Quick Start

```bash
npx reis-cli create
# or run via npm script if installed locally
```

You’ll be prompted for:

* **Project name** (kebab-case)
* **Preset**: `minimal` or `crud`
* **Database** (for `crud`): `sqlite` | `postgres` | `mongo`
* **Features** (multi-select): `rabbitmq`, `swagger`, `auth-jwt`, `loki-logger`, `redis`
* **Env profile**: `basic` or `full`
* **Package manager**: npm | yarn | pnpm

Then:

```bash
cd <project-name>
npm install
npm run dev
npm test
```

> Each DB/feature includes its own README (generated) with setup notes.

---

## 📦 What It Generates

**Base** (shared):

* `src/app/app.ts`, `src/app/middlewares`, `src/routes`, `src/utils/logger.ts`, `src/server.ts`
* TypeScript config, ESLint/Prettier, Vitest config, basic tests

**Preset `minimal`**:

* Healthcheck route, welcome route, error handler, logging

**Preset `crud`**:

* Users domain: `controllers/`, `services/`, `repositories/` with a **repository interface** and DB-specific implementation
* Integration tests for endpoints

**DB Packs**:

* **SQLite (Prisma)**: `prisma/schema.prisma`, migration commands, `test.db` isolation
* **Postgres (pg)**: SQL DDL in repo, Testcontainers bootstrapping for tests
* **Mongo (Mongoose)**: models + in-memory server for tests

**Feature Packs** (independent, easy to wire):

* **RabbitMQ**: `messaging/rabbit.ts`, `publisher.ts`, `consumer.ts` (no hard coupling)
* **Swagger**: `docs/swagger.ts` + JSDoc examples in route files; `/docs`
* **Auth JWT**: `auth/jwt.ts`, `middlewares/auth.ts` (+ `express.d.ts` types)
* **Loki**: overlay for `utils/logger.ts` adding Loki transport if `LOKI_URL` is set
* **Redis**: `cache/redis.ts` with `cacheGet/Set/Del/withCache` and no-op fallback

---

## 🧪 Testing Strategy

* **Vitest** globals or imports (project chooses); integration with **Supertest**.
* **Coverage**: LCOV at `coverage/lcov.info` (CI-friendly).
* **DB-specific**:

  * SQLite: runs Prisma migrations; dev DB (`dev.db`) vs test DB (`test.db`).
  * Postgres: Testcontainers spins ephemeral PG during tests.
  * Mongo: mongodb-memory-server (no external service).
* **Features**:

  * RabbitMQ & Redis tests are **mocked** (no external services required).

---

## 🧱 Template System

* Every file is a **.tpl** or plain file; the generator interpolates variables like `{{projectName}}`.
* **Overlays** merge by path precedence: `base` → `preset` → `db` → `features` → `env`.
* Extra dependencies/scripts are merged via `package.extra.json.tpl` → into `package.json`.

---

## 🔧 Env Profiles

* **basic**: minimal `.env` (e.g., `DATABASE_URL` for SQLite) to start coding quickly.
* **full**: extended `.env` hints for infra (CI/CD, registry, ingress, etc.).

---

## 🛠 Recommended Workflow

1. Generate project (preset + DB + features).
2. Follow the generated **DB/feature README** for any setup (e.g., `npx prisma migrate dev`).
3. Run `npm test` and check coverage.
4. Start coding domain logic; plug features where needed (e.g., publish RabbitMQ after creating a user, guard routes with JWT, cache read paths with Redis, etc.).

---

## 🧰 CI/CD & Deploy

* VCS-ready: includes scripts and coverage output compatible with CI (e.g., Woodpecker).
* Optional deployment scaffolds (`deploy.values.yaml`, Dockerfile) can be templated per project.

---

## 🩹 Troubleshooting

* **Module not found**: check feature overlays and import paths (e.g., Swagger import path `../docs/swagger`).
* **Prisma error (SQLite)**: ensure `.env` has `DATABASE_URL="file:./dev.db"` before running `npx prisma migrate dev`.
* **Postgres tests fail**: Docker must be running for Testcontainers.
* **Mongo tests fail**: ensure memory-server can download binaries (internet access) or set mirror vars.
* **Loki not sending logs**: set `LOKI_URL` and valid JSON in `LOKI_LABELS` (falls back to console if missing/invalid).
* **Redis not available**: helpers degrade to no-op; set `REDIS_URL` to enable caching.

---

## License

MIT — do awesome things.
