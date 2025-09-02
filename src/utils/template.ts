import fs from "fs-extra";
import path from "path";
import { fileURLToPath } from "url";

export function resolveFromSrc(relPath: string) {
  const __filename = fileURLToPath(import.meta.url);
  const __dirname = path.dirname(__filename);
  return path.join(__dirname, "..", relPath);
}

export function resolveTemplateRoot() {
  const __filename = fileURLToPath(import.meta.url);
  const __dirname = path.dirname(__filename);

  const candidates = [
    path.resolve(__dirname, "..", "templates"),
    path.resolve(__dirname, "..", "..", "templates"),
    path.resolve(__dirname, "..", "..", "src", "templates"),
  ];

  for (const p of candidates) {
    if (fs.existsSync(p)) return p;
  }

  throw new Error(
    `Templates folder not found. Tried:\n${candidates.join("\n")}\n` +
      `Tip: include the correct folder in "files" (e.g. "templates" or "src/templates") in package.json.`
  );
}

export function resolveTemplatePath(subpath: string) {
  return path.join(resolveTemplateRoot(), subpath);
}

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

type CopyOptions = {
  exclude?: (relPath: string, entry: fs.Dirent) => boolean;
};

export async function copyTemplateDir(
  srcDir: string,
  destDir: string,
  vars: Record<string, string>,
  opts: CopyOptions = {}
) {
  if (!(await fs.pathExists(srcDir))) {
    throw new Error(
      `Template directory not found: ${srcDir}\n` +
        `> Dica: verifique se "templates" está incluído em "files" no package.json e o caminho correto é templates/app/...`
    );
  }

  const entries = await fs.readdir(srcDir, { withFileTypes: true });
  await fs.ensureDir(destDir);

  for (const entry of entries) {
    const srcPath = path.join(srcDir, entry.name);
    const rel = entry.name;
    if (opts.exclude && opts.exclude(rel, entry)) {
      continue;
    }

    if (entry.isDirectory()) {
      await copyTemplateDir(srcPath, path.join(destDir, entry.name), vars, {
        exclude: (childRel, e) => {
          const fullRel = path.posix.join(rel, childRel);
          return opts.exclude ? opts.exclude(fullRel, e) : false;
        },
      });
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
