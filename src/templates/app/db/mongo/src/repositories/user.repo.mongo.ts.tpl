import mongoose, { Schema, Model } from "mongoose";
import type { UserRepo, User, CreateUser, UpdateUser } from "./user.repo";

type UserDoc = mongoose.Document & User;
let UserModel: Model<UserDoc>;

function connectUri() {
  return process.env.MONGO_URL || "mongodb://localhost:27017/{{projectName}}";
}

function ensureModel() {
  if (UserModel) return;
  const UserSchema = new Schema<User>({
    id: { type: String, required: true, unique: true },
    name: String,
    email: { type: String, unique: true },
    createdAt: Date,
    updatedAt: Date
  });
  UserModel = mongoose.model<UserDoc>("User", UserSchema);
}

export const mongoUserRepo: UserRepo = {
  async init() {
    if (mongoose.connection.readyState === 0) {
      await mongoose.connect(connectUri());
    }
    ensureModel();
    await UserModel.deleteMany({});
  },
  async findAll() {
    ensureModel();
    const docs = await UserModel.find({}).sort({ createdAt: -1 }).lean();
    return docs.map(d => ({ ...d, createdAt: new Date(d.createdAt), updatedAt: new Date(d.updatedAt) } as User));
  },
  async findById(id: string) {
    ensureModel();
    const d = await UserModel.findOne({ id }).lean();
    return d ? ({ ...d, createdAt: new Date(d.createdAt), updatedAt: new Date(d.updatedAt) } as User) : null;
  },
  async create(data: CreateUser) {
    ensureModel();
    const id = Date.now().toString(36) + Math.random().toString(36).slice(2, 8);
    const now = new Date();
    const doc = await UserModel.create({ id, name: data.name, email: data.email, createdAt: now, updatedAt: now });
    return { id, name: doc.name!, email: doc.email!, createdAt: now, updatedAt: now };
  },
  async update(id: string, data: UpdateUser) {
    ensureModel();
    const now = new Date();
    const doc = await UserModel.findOneAndUpdate({ id }, { ...data, updatedAt: now }, { new: true }).lean();
    return doc ? ({ ...doc, createdAt: new Date(doc.createdAt), updatedAt: new Date(doc.updatedAt) } as User) : null;
  },
  async remove(id: string) {
    ensureModel();
    const res = await UserModel.deleteOne({ id });
    return res.deletedCount === 1;
  },
};
