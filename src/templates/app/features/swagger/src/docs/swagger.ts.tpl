import swaggerJsdoc from "swagger-jsdoc";
import swaggerUi from "swagger-ui-express";
import { Express } from "express";
import fs from "node:fs";

export function applySwagger(app: Express) {
  const pkg = fs.existsSync("./package.json")
    ? JSON.parse(fs.readFileSync("./package.json", "utf8"))
    : { name: "{{projectName}}", version: "0.1.0" };

  const options: swaggerJsdoc.Options = {
    definition: {
      openapi: "3.0.3",
      info: {
        title: pkg.name || "{{projectName}}",
        version: pkg.version || "0.1.0"
      },
      servers: [{ url: "http://localhost:3000" }]
    },
    // 👇 arquivos com JSDoc nas rotas:
    apis: ["./src/**/*.ts"]
  };

  const spec = swaggerJsdoc(options);
  app.use("/docs", swaggerUi.serve, swaggerUi.setup(spec, { explorer: true }));
  // JSON cru (útil pra CI/validação)
  app.get("/docs.json", (_req, res) => res.json(spec));
}
