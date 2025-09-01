import { getUserRepo, User, CreateUser, UpdateUser } from "../repositories/user.repo";

const repo = getUserRepo();

export async function findAll(): Promise<User[]> {
  return repo.findAll();
}
export async function findById(id: string): Promise<User | null> {
  return repo.findById(id);
}
export async function create(data: CreateUser): Promise<User> {
  return repo.create(data);
}
export async function update(id: string, data: UpdateUser): Promise<User | null> {
  return repo.update(id, data);
}
export async function remove(id: string): Promise<boolean> {
  return repo.remove(id);
}
