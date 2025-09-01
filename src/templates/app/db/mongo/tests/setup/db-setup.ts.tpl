import { MongoMemoryServer } from "mongodb-memory-server";

// start memory server and set URL BEFORE loading repo index
const mongod = await MongoMemoryServer.create();
process.env.MONGO_URL = mongod.getUri();

await import("../../src/repositories/index"); // registra mongoUserRepo

// opcional: encerrar ao final do processo
process.on("exit", async () => {
  try { await mongod.stop(); } catch {}
});
