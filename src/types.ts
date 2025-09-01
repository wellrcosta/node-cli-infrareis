export type Preset = "minimal" | "crud";
export type Feature = "rabbitmq";
export type DbOption = "none" | "sqlite" | "postgres" | "mongo";
export type EnvProfile = "basic" | "full";

export interface Answers {
  projectName: string;
  preset: Preset;
  features: Feature[];
  db: DbOption;
  envProfile: EnvProfile;
}
