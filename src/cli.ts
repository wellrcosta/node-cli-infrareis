import inquirer from "inquirer";
import { Command } from "commander";
import path from "path";
import chalk from "chalk";

import { generate } from "./generator/index.js";
import type { Answers } from "./types.js";

export function buildProgram() {
  const program = new Command()
    .name("create-app")
    .description("Gerador de app (minimal/crud + opções)")
    .version("0.1.0");

  program
    .command("create")
    .description("Criar um novo projeto")
    .action(async () => {
      console.log(chalk.blue("\n🚀 App Generator\n"));

      const answers = await inquirer.prompt<Answers>([
        {
          type: "input",
          name: "projectName",
          message: "Nome do projeto:",
          validate: (s) =>
            (!!s && /^[a-z0-9-]+$/.test(s)) ||
            "Use minúsculas, números e hífens",
        },
        {
          type: "list",
          name: "preset",
          message: "Preset:",
          choices: [
            { name: "Minimal", value: "minimal" },
            { name: "CRUD", value: "crud" },
          ],
        },
        {
          type: "list",
          name: "db",
          message: "Banco de dados:",
          when: (a) => a.preset === "crud",
          choices: [
            { name: "SQLite (Prisma)", value: "sqlite" },
            { name: "Mongo (Mongoose)", value: "mongo" },
            { name: "Postgres (pg)", value: "postgres" },
          ],
        },
        {
          type: "checkbox",
          name: "features",
          message: "Features opcionais:",
          choices: [
            { name: "RabbitMQ", value: "rabbitmq" },
            { name: "Swagger (OpenAPI por JSDoc)", value: "swagger" },
            { name: "Auth JWT", value: "auth-jwt" },
            { name: "Loki (logs para Grafana)", value: "loki-logger" },
            { name: "Redis (cache)", value: "redis" },
          ],
          default: [],
          loop: false,
          pageSize: 10,
        },
        {
          type: "list",
          name: "envProfile",
          message: "Perfil de .env:",
          choices: [
            { name: "Básico", value: "basic" },
            { name: "Completo (infra)", value: "full" },
          ],
        },
        {
          type: "list",
          name: "packageManager",
          message: "Gerenciador de pacotes:",
          choices: ["npm", "yarn", "pnpm"],
          default: "npm",
        },
      ]);

      if (answers.preset === "minimal") {
        answers.db = "none";
      }

      console.log("\nResumo do projeto:");
      console.log(`- Preset: ${answers.preset}`);
      console.log(`- DB: ${answers.db}`);
      console.log(
        `- Features: ${
          answers.features.length ? answers.features.join(", ") : "nenhuma"
        }`
      );
      console.log(`- .env: ${answers.envProfile}`);
      console.log();

      const projectPath = path.join(process.cwd(), answers.projectName);
      await generate(projectPath, answers);
    });

  return program;
}
