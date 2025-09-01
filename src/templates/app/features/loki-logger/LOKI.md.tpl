# {{projectName}} + Loki (Grafana)

Envio de logs para **Grafana Loki** via `winston-loki`.

## Variáveis `.env`
```env
LOKI_URL=http://loki:3100
LOKI_LABELS={"service":"{{projectName}}","env":"dev"}
LOG_LEVEL=info
Como funciona
Se LOKI_URL não estiver definido, logs vão somente para Console.

Se definido, um transport Loki é adicionado e os logs estruturados são encaminhados ao Loki.

Labels podem ser um JSON com chaves customizadas (ex.: team, version, etc).

Testes
Os testes são isolados (não precisam de Loki real):

bash
Copiar código
npm test
Dica de Grafana
Crie um Data Source Loki apontando para LOKI_URL e filtre por {service="{{projectName}}"}.

markdown
Copiar código

---

## Como plugar no CLI

- Quando o usuário marcar **auth-jwt**:
  - adicionar dependências
  - copiar `src/auth/*`, `src/middlewares/auth.ts`, `src/types/express.d.ts`, testes e README

- Quando marcar **loki-logger**:
  - adicionar `winston-loki`
  - **sobrepor** `src/utils/logger.ts` pelo desta feature
  - copiar testes e README