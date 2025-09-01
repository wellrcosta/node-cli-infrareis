import { Request, Response, NextFunction } from "express";
import { verifyToken } from "../auth/jwt";

export function authenticateJwt(req: Request, res: Response, next: NextFunction) {
  const header = req.headers.authorization || "";
  const [type, token] = header.split(" ");
  if (type !== "Bearer" || !token) {
    return res.status(401).json({ error: "Unauthorized" });
  }
  try {
    const payload = verifyToken(token);
    (req as any).user = payload;
    next();
  } catch {
    return res.status(401).json({ error: "Unauthorized" });
  }
}
