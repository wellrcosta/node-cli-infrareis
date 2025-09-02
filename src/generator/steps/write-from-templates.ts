import path from "path";
import fs from "fs-extra";
import { copyTemplateDir, resolveTemplatePath } from "../../utils/template.js";
import type { Answers } from "../../types.js";

export function selectPacks(cfg: Answers) {
  const root = resolveTemplatePath("app");

  const packs: string[] = [
    path.join(root, "base"),
    path.join(root, "presets", cfg.preset),
  ];

  if (cfg.db && cfg.db !== "none") {
    packs.push(path.join(root, "db", cfg.db));
  }

  for (const feat of cfg.features || []) {
    packs.push(path.join(root, "features", feat));
    const presetOverlay = path.join(
      root,
      "features",
      feat,
      "presets",
      cfg.preset
    );
    if (fs.existsSync(presetOverlay)) {
      packs.push(presetOverlay);
    }
  }

  packs.push(path.join(root, "env", cfg.envProfile));

  return packs;
}

export async function writeFromTemplates(projectPath: string, cfg: Answers) {
  const packs = selectPacks(cfg);
  const vars = { projectName: cfg.projectName };

  await fs.ensureDir(projectPath);

  for (const p of packs) {
    const isFeatureRoot = /[/\\]features[/\\][^/\\]+$/.test(p);

    const opts = isFeatureRoot
      ? {
          exclude: (rel: string) =>
            rel === "presets" || rel.startsWith("presets/"),
        }
      : undefined;

    await copyTemplateDir(p, projectPath, vars, opts as any);
  }

  return packs;
}
