# {{projectName}} + Swagger (OpenAPI)

Esta feature adiciona Swagger ao projeto e permite **documentar as rotas via JSDoc** diretamente nos arquivos de rota.

- UI: `GET /docs`
- Spec JSON: `GET /docs.json`

## Como funciona

- A função `applySwagger(app)` registra as rotas `/docs` e `/docs.json`.
- O `swagger-jsdoc` varre `./src/**/*.ts` e lê os blocos `@openapi` nos arquivos de rota.
- Os exemplos de JSDoc foram adicionados às rotas (`src/routes/...`).

## Onde escrever a documentação

Edite os blocos `@openapi` nos próprios arquivos de rota (ex.: `users.routes.ts`).  
Exemplo (POST /api/users):

```ts
/**
 * @openapi
 * /api/users:
 *   post:
 *     summary: Cria usuário
 *     tags: [Users]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [name, email]
 *             properties:
 *               name: { type: string }
 *               email: { type: string, format: email }
 *     responses:
 *       201: { description: Criado }
 */

Dicas

Ajuste servers[0].url em src/docs/swagger.ts para apontar para o host real.

Para dividir schemas grandes, preferir components/schemas no final do arquivo de rotas ou em módulos compartilhados.

---

## como usar no CLI

- Se o usuário marcar **feature “swagger”**, o gerador:
  - adiciona dependências (`swagger-jsdoc`, `swagger-ui-express`);
  - copia `src/docs/swagger.ts`;
  - **sobrepõe** `src/app/app.ts` com a versão que chama `applySwagger(app)` (tem overlay separado pra `minimal` e pra `crud`);
  - sobrepõe as rotas com JSDoc de exemplo (no minimal `index.ts`, no CRUD `users.routes.ts`);
  - adiciona o teste `docs.test.ts` (opcional, mas bom pra garantir que o spec gera).

-> resultado: **imediatamente acessível em `/docs`** e **você edita a doc dentro das rotas**.
