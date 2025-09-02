import { Request, Response, NextFunction } from "express";
import * as service from "../services/users.service";

export async function list(_req: Request, res: Response, next: NextFunction) {
  try { res.json(await service.findAll()); } catch (e) { next(e); }
}
export async function getById(req: Request, res: Response, next: NextFunction) {
  try {
    const user = await service.findById(req.params.id);
    if (!user) return res.status(404).json({ error: "User not found" });
    res.json(user);
  } catch (e) { next(e); }
}
export async function create(req: Request, res: Response, next: NextFunction) {
  try {
    const { name, email } = req.body || {};
    if (!name || !email) return res.status(400).json({ error: "name and email are required" });
    const user = await service.create({ name, email });
    res.status(201).json(user);
  } catch (e) { next(e); }
}
export async function update(req: Request, res: Response, next: NextFunction) {
  try {
    const { name, email } = req.body || {};
    const user = await service.update(req.params.id, { name, email });
    if (!user) return res.status(404).json({ error: "User not found" });
    res.json(user);
  } catch (e) { next(e); }
}
export async function remove(req: Request, res: Response, next: NextFunction) {
  try {
    const ok = await service.remove(req.params.id);
    if (!ok) return res.status(404).json({ error: "User not found" });
    res.status(204).send();
  } catch (e) { next(e); }
}
