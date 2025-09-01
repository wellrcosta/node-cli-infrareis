# {{projectName}} (CRUD + Prisma + SQLite)

Este projeto foi gerado com o **Boilerplate Generator** no preset **CRUD** usando **Prisma + SQLite**.

---

## 🚀 Primeiros passos

1. Instale as dependências:

   ```bash
   npm install
   ```

2. Configure a variável de ambiente do banco:
   Crie um arquivo `.env` na raiz:

   ```env
   DATABASE_URL="file:./dev.db"
   ```

3. Gere o cliente Prisma e rode a migration inicial:

   ```bash
   npx prisma generate
   npx prisma migrate dev --name init
   ```

Isso criará o banco `dev.db` e as tabelas necessárias.

---

## 🖥️ Rodar o servidor

```bash
npm run dev
```

Servidor estará rodando em `http://localhost:3000`.

Endpoints principais:

* `GET /health` → status
* `GET /api/users` → lista usuários
* `POST /api/users` → cria usuário `{ "name": "...", "email": "..." }`
* `GET /api/users/:id` → busca usuário
* `PUT /api/users/:id` → atualiza
* `DELETE /api/users/:id` → remove

---

## 🧪 Testes

Testes usam **Vitest + Supertest**.

Rode com:

```bash
npm test
npm run test:coverage
```

### Banco de testes

Nos testes, o Prisma aponta para `file:./test.db`.
Isso garante isolamento entre o banco de dev e o banco de teste.

O setup de testes (`tests/setup/db-setup.ts`) roda `npx prisma migrate deploy` automaticamente para preparar `test.db` antes de rodar os testes.

---

## 🔧 Comandos úteis do Prisma

* abrir o Studio (interface web para ver dados):

  ```bash
  npx prisma studio
  ```

* criar uma nova migration:

  ```bash
  npx prisma migrate dev --name <nome>
  ```

* aplicar migrations no ambiente de teste:

  ```bash
  npx prisma migrate deploy
  ```

---

## 📂 Estrutura resumida

```
src/
  app/              # Express app
  controllers/      # Controllers CRUD
  services/         # Regras de negócio
  repositories/     # Interface + implementação Prisma
  routes/           # Rotas Express
  utils/            # Logger etc.
prisma/
  schema.prisma     # Definição do modelo (User)
tests/
  integration/      # Testes e2e das rotas
  setup/            # Setup de banco para testes
```

---

## ⚠️ Observações

* Se der erro `Environment variable not found: DATABASE_URL`, confira se o `.env` existe e contém a variável.
* Cada vez que você alterar `prisma/schema.prisma`, rode:

  ```bash
  npx prisma generate
  ```

  para atualizar o cliente.

---
