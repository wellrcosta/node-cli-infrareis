import inquirer from "inquirer";
import { Command } from "commander";
import path from "path";
import chalk from "chalk";
import { generate } from "./generator";
import { Answers, DbOption, EnvProfile, Feature, Preset } from "./types";

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
          message: "Nome do projeto (kebab-case):",
          validate: (s: string) =>
            /^[a-z0-9-]+$/.test(s) ? true : "use minúsculas, números e hífens",
        },
        {
          type: "list",
          name: "preset",
          message: "Preset:",
          choices: [
            {
              name: "Minimal (HTTP + health)",
              value: "minimal" satisfies Preset,
            },
            { name: "CRUD (Users)", value: "crud" satisfies Preset },
          ],
          default: "minimal",
        },
        {
          type: "checkbox",
          name: "features",
          message: "Features:",
          choices: [{ name: "RabbitMQ", value: "rabbitmq" satisfies Feature }],
          default: [],
        },
        {
          type: "list",
          name: "db",
          message: "Banco de dados:",
          choices: [
            { name: "Nenhum (em memória)", value: "none" as DbOption },
            { name: "SQLite", value: "sqlite" as DbOption },
            { name: "Postgres", value: "postgres" as DbOption },
            { name: "MongoDB", value: "mongo" as DbOption },
          ],
          default: "none",
        },
        {
          type: "list",
          name: "envProfile",
          message: "Perfil do .env:",
          choices: [
            { name: "Básico", value: "basic" as EnvProfile },
            { name: "Completo (arquitetura)", value: "full" as EnvProfile },
          ],
          default: "basic",
        },
      ]);

      const projectPath = path.join(process.cwd(), answers.projectName);
      await generate(projectPath, answers);
    });

  return program;
}
