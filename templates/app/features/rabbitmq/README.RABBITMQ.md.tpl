# {{projectName}} + RabbitMQ

Este projeto foi gerado com o **Boilerplate Generator** com a feature **RabbitMQ** habilitada.

---

## 🚀 Primeiros passos

1. Inicie um RabbitMQ local (ou em container):

```bash
docker run -d --name rabbit -p 5672:5672 -p 15672:15672 rabbitmq:3-management
```

* Painel de administração: [http://localhost:15672](http://localhost:15672)
  Usuário: `guest` / Senha: `guest`

2. Configure as variáveis no `.env`:

```env
RABBITMQ_URL=amqp://guest:guest@localhost:5672
RABBITMQ_QUEUE={{projectName}}-queue
```

---

## 🧩 Uso básico

### Publisher

```ts
import { publishMessage } from "./messaging/publisher";

await publishMessage({ type: "USER_CREATED", payload: { id: "123" } });
```

### Consumer

```ts
import { consumeMessages } from "./messaging/consumer";

consumeMessages(async (msg) => {
  console.log("Mensagem recebida:", msg);
});
```

> O consumer fica escutando a fila definida em `RABBITMQ_QUEUE`.

---

## 🧪 Testes

Os testes de RabbitMQ são **mockados** com Vitest.  
Não é necessário rodar um RabbitMQ real.

Rode:

```bash
npm test
```

---

## ⚠️ Observações

* Esta feature não está integrada por padrão em nenhum controller/service.
* Para acoplar, basta importar `publishMessage` nos pontos que desejar (ex.: após criar um usuário).
* Você pode ter múltiplas filas alterando `RABBITMQ_QUEUE` ou instanciando manualmente canais adicionais.

---
