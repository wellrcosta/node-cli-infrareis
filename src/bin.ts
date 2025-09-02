#!/usr/bin/env node
import pkg from "../package.json" with { type: "json" };

type NotifierFn = (args: { pkg: any; shouldNotifyInNpmScript?: boolean }) => any;
async function notifyUpdate() {
  try {
    const mod = await import("simple-update-notifier");
    const fn: NotifierFn = (mod as any).default ?? (mod as any);
    await fn({ pkg, shouldNotifyInNpmScript: true });
  } catch {
  }
}
await notifyUpdate();

import { buildProgram } from "./cli.js";
const program = buildProgram();
await program.parseAsync(process.argv);
