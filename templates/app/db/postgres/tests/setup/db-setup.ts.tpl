import { GenericContainer, StartedTestContainer } from "testcontainers";

let container: StartedTestContainer | null = null;

container = await new GenericContainer("postgres:16-alpine")
  .withEnvironment({
    POSTGRES_USER: "postgres",
    POSTGRES_PASSWORD: "postgres",
    POSTGRES_DB: "{{projectName}}_test",
  })
  .withExposedPorts(5432)
  .start();

process.env.PGHOST = container.getHost();
process.env.PGPORT = String(container.getMappedPort(5432));
process.env.PGUSER = "postgres";
process.env.PGPASSWORD = "postgres";
process.env.PGDATABASE = "{{projectName}}_test";

await import("../../src/repositories/index"); // registra pgUserRepo

// encerra ao sair
process.on("exit", async () => {
  try { await container?.stop(); } catch {}
});
