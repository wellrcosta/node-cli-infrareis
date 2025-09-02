# {{projectName}} (CRUD + MongoDB)

Este projeto foi gerado com o **Boilerplate Generator** no preset **CRUD** usando **MongoDB**.

---

## 🚀 Primeiros passos

1. Instale as dependências:

   ```bash
   npm install
   ```

2. Configure a variável de ambiente do banco:
   Crie um arquivo `.env` na raiz:

   ```env
   MONGO_URL="mongodb://localhost:27017/{{projectName}}"
   ```

   > ⚠️ Ajuste a URL se seu MongoDB estiver em outro host/porta.

3. Inicie o MongoDB (local ou em container):

   ```bash
   docker run -d --name {{projectName}}-mongo -p 27017:27017 mongo:7
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

Nos testes, é usado **mongodb-memory-server** para rodar um Mongo em memória.
Isso significa que os testes não precisam de Mongo real e são totalmente isolados.

O setup de testes (`tests/setup/db-setup.ts`) cria a instância em memória, conecta via Mongoose e fecha ao final.

---

## 📂 Estrutura resumida

```
src/
  app/              # Express app
  controllers/      # Controllers CRUD
  services/         # Regras de negócio
  repositories/     # Interface + implementação Mongoose
  routes/           # Rotas Express
  utils/            # Logger etc.
tests/
  integration/      # Testes e2e das rotas
  setup/            # Setup do banco de testes (mongodb-memory-server)
```

---

## ⚠️ Observações

* É preciso que o Mongo esteja disponível em desenvolvimento (local ou container).
* Nos testes não há dependência externa, o banco em memória é usado automaticamente.
* Alterar schema? Ajuste o `user.model.ts` e os métodos no repositório Mongoose.

---
