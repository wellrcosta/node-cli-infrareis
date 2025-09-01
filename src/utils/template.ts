import fs from "fs-extra";
import path from "path";
import { fileURLToPath } from "url";

/** Resolve caminho relativo ao diretório src/ */
export function resolveFromSrc(relPath: string) {
  const __filename = fileURLToPath(import.meta.url);
  const __dirname = path.dirname(__filename);
  return path.join(__dirname, "..", relPath);
}

/** Renderiza {{chave}} -> valor (string) */
export async function renderTemplateFile(
  tplPath: string,
  vars: Record<string, string>
) {
  let content = await fs.readFile(tplPath, "utf8");
  for (const [key, val] of Object.entries(vars)) {
    content = content.replace(new RegExp(`{{${key}}}`, "g"), val);
  }
  return content;
}

/** Copia diretório de templates .tpl (render + remove extensão .tpl) */
export async function copyTemplateDir(
  srcDir: string,
  destDir: string,
  vars: Record<string, string>
) {
  const entries = await fs.readdir(srcDir, { withFileTypes: true });
  await fs.ensureDir(destDir);

  for (const entry of entries) {
    const srcPath = path.join(srcDir, entry.name);
    if (entry.isDirectory()) {
      await copyTemplateDir(srcPath, path.join(destDir, entry.name), vars);
      continue;
    }
    const isTpl = entry.isFile() && entry.name.endsWith(".tpl");
    if (isTpl) {
      const outName = entry.name.slice(0, -4);
      const outPath = path.join(destDir, outName);
      const rendered = await renderTemplateFile(srcPath, vars);
      await fs.outputFile(outPath, rendered);
    } else if (entry.isFile()) {
      await fs.copy(srcPath, path.join(destDir, entry.name));
    }
  }
}
