import ora from "ora";
import fs from "fs-extra";
import path from "path";
import { Answers } from "../types";
import { writeFromTemplates } from "./steps/write-from-templates";
import { patchPackageJson } from "./steps/patch-package-json";

export async function generate(projectPath: string, cfg: Answers) {
  const spin = ora("Gerando projeto...").start();
  try {
    await fs.ensureDir(projectPath);
    const packs = await writeFromTemplates(projectPath, cfg);
    await patchPackageJson(projectPath, packs);

    spin.succeed("Projeto criado com sucesso!");
    console.log("\nPróximos passos:");
    console.log(`  cd ${cfg.projectName}`);
    console.log(`  npm install`);
    console.log(`  npm run dev`);
    console.log(`  npm test`);
  } catch (e) {
    spin.fail("Falha ao criar o projeto");
    throw e;
  }
}
