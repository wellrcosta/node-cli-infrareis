import jwt from "jsonwebtoken";

const DEFAULT_ALG = "HS256";
function secret() {
  const s = process.env.JWT_SECRET;
  if (!s) throw new Error("JWT_SECRET não definido");
  return s;
}
function expires() {
  return process.env.JWT_EXPIRES_IN || "15m";
}

export function signToken<T extends object>(payload: T): string {
  return jwt.sign(payload, secret(), { algorithm: DEFAULT_ALG, expiresIn: expires() });
}

export function verifyToken<T = any>(token: string): T {
  return jwt.verify(token, secret(), { algorithms: [DEFAULT_ALG] }) as T;
}
