import path from "path";
import fs from "fs-extra";
import { copyTemplateDir, resolveFromSrc } from "../../utils/template";
import { Answers } from "../../types";

export function selectPacks(cfg: Answers) {
  const root = resolveFromSrc("templates/app");
  const packs: string[] = [
    path.join(root, "base"),
    path.join(root, "presets", cfg.preset),
  ];
  for (const feat of cfg.features || []) {
    packs.push(path.join(root, "features", feat));
  }
  if (cfg.db && cfg.db !== "none") {
    packs.push(path.join(root, "db", cfg.db));
  }
  packs.push(path.join(root, "env", cfg.envProfile));
  return packs;
}

export async function writeFromTemplates(projectPath: string, cfg: Answers) {
  const packs = selectPacks(cfg);
  const vars = { projectName: cfg.projectName };

  await fs.ensureDir(projectPath);
  for (const p of packs) {
    await copyTemplateDir(p, projectPath, vars);
  }
  return packs;
}
