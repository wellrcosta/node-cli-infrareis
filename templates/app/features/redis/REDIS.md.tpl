# {{projectName}} + Redis (cache opcional)

Feature opcional de **cache Redis** para usar em qualquer preset (Minimal ou CRUD).

---

## 🚀 Visão geral

* Conexão via **ioredis** (produção/dev)
* Testes **mockados** com **ioredis-mock** (não precisa Redis real)
* Helpers prontos: `cacheGet`, `cacheSet`, `cacheDel`, `withCache`
* Config mínima via `.env`

---

## ⚙️ Variáveis de ambiente

Coloque no `.env` do projeto:

```env
REDIS_URL=redis://localhost:6379
REDIS_DEFAULT_TTL=300
```

* `REDIS_URL` → URL do Redis. Se ausente, os helpers entram em **modo no-op** (não quebram o app).
* `REDIS_DEFAULT_TTL` → TTL padrão (em segundos) usado por `withCache`.

---

## 🔌 Como usar no código

### Helpers básicos

```ts
import { cacheGet, cacheSet, cacheDel } from "./cache/redis";

// salvar
await cacheSet("users:all", users, 120); // TTL 120s

// ler
const cached = await cacheGet("users:all");

// invalidar
await cacheDel("users:all");
```

### Cache por função (`withCache`)

```ts
import { withCache } from "./cache/redis";

const users = await withCache({ key: "users:all", ttl: 300 }, async () => {
  // busca "cara" (DB, HTTP, etc.)
  return await repo.findAll();
});
```

> Se `REDIS_URL` não estiver definido, `withCache` apenas executa a função e retorna o valor (sem cache).

---

## 🧪 Testes (mockados)

* Os testes desta feature usam **ioredis-mock**.
* Não é necessário ter Redis real rodando.

Para rodar:

```bash
npm test
```

---

## 💡 Boas práticas

* Use chaves com prefixo de domínio: `users:byId:123`, `orders:recent`, etc.
* Invalide chaves relevantes após operações de escrita (POST/PUT/DELETE).
* Considere TTLs pequenos em dados mutáveis e maiores em dados estáveis.

---

## 🧰 Exemplo de integração com CRUD (opcional)

No service de usuários, você pode cachear a listagem:

```ts
import { withCache, cacheDel } from "./cache/redis";

export async function findAll() {
  return withCache({ key: "users:all", ttl: 120 }, () => repo.findAll());
}

export async function create(dto) {
  const u = await repo.create(dto);
  await cacheDel("users:all");
  return u;
}
```

---

## Troubleshooting

* **Sem REDIS\_URL**: os helpers viram no-op → nada quebra, apenas não há cache.
* **Conexão falhou**: a feature loga um aviso e volta a no-op (para não interromper o startup).
* **TTL**: lembre que TTL é em **segundos**.

---
