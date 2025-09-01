import Database from "better-sqlite3";
import type { UserRepo, User, CreateUser, UpdateUser } from "./user.repo";

let db: Database.Database | null = null;
let memoryMode = false;

function openDb() {
  if (db) return db;
  const url = process.env.SQLITE_PATH || "./data.sqlite";
  memoryMode = url === ":memory:";
  db = new Database(url);
  db.pragma("journal_mode = WAL");
  db.exec(`
    CREATE TABLE IF NOT EXISTS users (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      createdAt TEXT NOT NULL,
      updatedAt TEXT NOT NULL
    );
  `);
  return db;
}

function toUser(row: any): User {
  return {
    id: row.id,
    name: row.name,
    email: row.email,
    createdAt: new Date(row.createdAt),
    updatedAt: new Date(row.updatedAt),
  };
}

export const sqliteUserRepo: UserRepo = {
  async init() {
    // para testes, se usar arquivo, limpa; se :memory:, já é novo a cada run
    const db = openDb();
    if (!memoryMode) {
      db.exec("DELETE FROM users;");
    }
  },
  async findAll() {
    const db = openDb();
    const rows = db.prepare("SELECT * FROM users ORDER BY createdAt DESC").all();
    return rows.map(toUser);
  },
  async findById(id: string) {
    const db = openDb();
    const row = db.prepare("SELECT * FROM users WHERE id = ?").get(id);
    return row ? toUser(row) : null;
  },
  async create(data: CreateUser) {
    const db = openDb();
    const id = Date.now().toString(36) + Math.random().toString(36).slice(2, 8);
    const now = new Date().toISOString();
    db.prepare(
      "INSERT INTO users (id, name, email, createdAt, updatedAt) VALUES (?, ?, ?, ?, ?)"
    ).run(id, data.name, data.email, now, now);
    return { id, name: data.name, email: data.email, createdAt: new Date(now), updatedAt: new Date(now) };
  },
  async update(id: string, data: UpdateUser) {
    const db = openDb();
    const current = db.prepare("SELECT * FROM users WHERE id = ?").get(id);
    if (!current) return null;
    const name = data.name ?? current.name;
    const email = data.email ?? current.email;
    const now = new Date().toISOString();
    db.prepare("UPDATE users SET name=?, email=?, updatedAt=? WHERE id=?").run(name, email, now, id);
    return { id, name, email, createdAt: new Date(current.createdAt), updatedAt: new Date(now) };
  },
  async remove(id: string) {
    const db = openDb();
    const res = db.prepare("DELETE FROM users WHERE id = ?").run(id);
    return res.changes > 0;
  },
};
