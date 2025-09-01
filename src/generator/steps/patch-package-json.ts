import fs from "fs-extra";
import path from "path";

type Json = Record<string, any>;

function deepMerge(a: Json, b: Json): Json {
  const out = { ...a };
  for (const [k, v] of Object.entries(b)) {
    if (v && typeof v === "object" && !Array.isArray(v)) {
      out[k] = deepMerge(out[k] || {}, v);
    } else {
      out[k] = v;
    }
  }
  return out;
}

export async function patchPackageJson(projectPath: string, packs: string[]) {
  const basePath = path.join(projectPath, "package.json");
  const basePkg: Json = await fs.readJSON(basePath);

  let merged = { ...basePkg };

  for (const p of packs) {
    const extraPath = path.join(p, "package.extra.json.tpl"); // opcional por pack
    if (await fs.pathExists(extraPath)) {
      const json = await fs.readJSON(extraPath);
      merged = deepMerge(merged, json);
    }
  }

  await fs.writeJSON(basePath, merged, { spaces: 2 });
}
