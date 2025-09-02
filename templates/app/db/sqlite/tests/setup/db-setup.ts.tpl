process.env.DATABASE_URL = "file:./test.db?connection_limit=1";

import { execSync } from "node:child_process";
import path from "path";

// roda migrations para preparar o banco de teste
const prismaDir = path.join(process.cwd(), "prisma");
execSync("npx prisma migrate deploy", { cwd: process.cwd(), stdio: "inherit" });

// registra repositório prisma
await import("../../src/repositories/index");
