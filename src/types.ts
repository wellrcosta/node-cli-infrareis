export type Preset = "minimal" | "crud";

export type Db = "none" | "sqlite" | "mongo" | "postgres";

export type Feature =
  | "rabbitmq"
  | "swagger"
  | "auth-jwt"
  | "loki-logger"
  | "redis";

export interface Answers {
  projectName: string;
  preset: Preset;
  db: Db;
  envProfile: "basic" | "full";
  features: Feature[];
  packageManager?: "npm" | "yarn" | "pnpm";
}
