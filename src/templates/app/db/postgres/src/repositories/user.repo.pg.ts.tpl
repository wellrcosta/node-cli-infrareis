import { Client } from "pg";
import type { UserRepo, User, CreateUser, UpdateUser } from "./user.repo";

let client: Client | null = null;

function connParams() {
  const url = process.env.DATABASE_URL;
  if (url) return { connectionString: url };
  return {
    host: process.env.PGHOST || "localhost",
    port: Number(process.env.PGPORT || 5432),
    user: process.env.PGUSER || "postgres",
    password: process.env.PGPASSWORD || "postgres",
    database: process.env.PGDATABASE || "{{projectName}}",
  };
}

async function getClient() {
  if (client) return client;
  client = new Client(connParams());
  await client.connect();
  await client.query(`
    CREATE TABLE IF NOT EXISTS users (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      created_at TIMESTAMP NOT NULL,
      updated_at TIMESTAMP NOT NULL
    );
  `);
  return client;
}

function toUser(row: any): User {
  return {
    id: row.id,
    name: row.name,
    email: row.email,
    createdAt: new Date(row.created_at),
    updatedAt: new Date(row.updated_at),
  };
}

export const pgUserRepo: UserRepo = {
  async init() {
    const c = await getClient();
    await c.query("DELETE FROM users;");
  },
  async findAll() {
    const c = await getClient();
    const { rows } = await c.query("SELECT * FROM users ORDER BY created_at DESC");
    return rows.map(toUser);
  },
  async findById(id: string) {
    const c = await getClient();
    const { rows } = await c.query("SELECT * FROM users WHERE id=$1", [id]);
    return rows[0] ? toUser(rows[0]) : null;
  },
  async create(data: CreateUser) {
    const c = await getClient();
    const id = Date.now().toString(36) + Math.random().toString(36).slice(2, 8);
    const now = new Date();
    await c.query(
      "INSERT INTO users (id,name,email,created_at,updated_at) VALUES ($1,$2,$3,$4,$5)",
      [id, data.name, data.email, now, now]
    );
    return { id, name: data.name, email: data.email, createdAt: now, updatedAt: now };
  },
  async update(id: string, data: UpdateUser) {
    const c = await getClient();
    const current = await this.findById(id);
    if (!current) return null;
    const name = data.name ?? current.name;
    const email = data.email ?? current.email;
    const now = new Date();
    await c.query("UPDATE users SET name=$1, email=$2, updated_at=$3 WHERE id=$4", [name, email, now, id]);
    return { id, name, email, createdAt: current.createdAt, updatedAt: now };
  },
  async remove(id: string) {
    const c = await getClient();
    const res = await c.query("DELETE FROM users WHERE id=$1", [id]);
    return res.rowCount === 1;
  },
};
