import { PrismaClient } from "@prisma/client";
import type { UserRepo, User, CreateUser, UpdateUser } from "./user.repo";

let prisma: PrismaClient | null = null;

function getPrisma() {
  if (!prisma) {
    prisma = new PrismaClient();
  }
  return prisma;
}

function map(u: any): User {
  return {
    id: u.id,
    name: u.name,
    email: u.email,
    createdAt: u.createdAt,
    updatedAt: u.updatedAt,
  };
}

export const prismaUserRepo: UserRepo = {
  async init() {
    const p = getPrisma();
    await p.user.deleteMany(); // limpa tabela nos testes
  },
  async findAll() {
    const p = getPrisma();
    const users = await p.user.findMany({ orderBy: { createdAt: "desc" } });
    return users.map(map);
  },
  async findById(id: string) {
    const p = getPrisma();
    const u = await p.user.findUnique({ where: { id } });
    return u ? map(u) : null;
  },
  async create(data: CreateUser) {
    const p = getPrisma();
    const u = await p.user.create({ data });
    return map(u);
  },
  async update(id: string, data: UpdateUser) {
    const p = getPrisma();
    try {
      const u = await p.user.update({ where: { id }, data });
      return map(u);
    } catch {
      return null;
    }
  },
  async remove(id: string) {
    const p = getPrisma();
    try {
      await p.user.delete({ where: { id } });
      return true;
    } catch {
      return false;
    }
  },
};
