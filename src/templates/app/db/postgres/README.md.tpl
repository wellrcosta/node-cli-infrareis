# {{projectName}} (CRUD + Postgres)

Este projeto foi gerado com o **Boilerplate Generator** no preset **CRUD** usando **Postgres**.

---

## 🚀 Primeiros passos

1. Instale as dependências:

   ```bash
   npm install
   ```

2. Configure a variável de ambiente do banco:
   Crie um arquivo `.env` na raiz:

   ```env
   PGHOST=localhost
   PGPORT=5432
   PGUSER=postgres
   PGPASSWORD=postgres
   PGDATABASE={{projectName}}
   ```

   > ⚠️ Substitua os valores conforme seu ambiente Postgres.

3. Inicie o banco (local ou em container) e crie o database se necessário:

   ```bash
   createdb -U postgres {{projectName}}
   ```

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

Nos testes, é usado **Testcontainers** para subir um Postgres temporário em Docker.
Isso garante que os testes sempre rodem em ambiente limpo.

> ⚠️ Necessário ter **Docker** rodando no host.

O setup de testes (`tests/setup/db-setup.ts`) cria o container, aplica o schema e derruba o banco ao final.

---

## 📂 Estrutura resumida

```
src/
  app/              # Express app
  controllers/      # Controllers CRUD
  services/         # Regras de negócio
  repositories/     # Interface + implementação Postgres (pg)
  routes/           # Rotas Express
  utils/            # Logger etc.
tests/
  integration/      # Testes e2e das rotas
  setup/            # Setup do banco de testes (Testcontainers)
```

---

## ⚠️ Observações

* É preciso que o Postgres esteja disponível em desenvolvimento (local ou container).
* Para rodar os testes, o **Docker precisa estar ativo** no ambiente.
* Alterar estrutura do banco? Atualize manualmente os comandos de `CREATE TABLE` no repositório.

---
