export interface User {
  id: string;
  name: string;
  email: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface CreateUser { name: string; email: string; }
export interface UpdateUser { name?: string; email?: string; }

export interface UserRepo {
  init?(): Promise<void>;
  findAll(): Promise<User[]>;
  findById(id: string): Promise<User | null>;
  create(data: CreateUser): Promise<User>;
  update(id: string, data: UpdateUser): Promise<User | null>;
  remove(id: string): Promise<boolean>;
}

let repoImpl: UserRepo | null = null;

export function setUserRepo(r: UserRepo) { repoImpl = r; }

export function getUserRepo(): UserRepo {
  if (!repoImpl) throw new Error("UserRepo não configurado. Verifique o pack do banco de dados.");
  return repoImpl;
}
