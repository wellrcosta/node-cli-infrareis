# {{projectName}} + Auth JWT

Feature opcional para proteger rotas com JWT.

## Variáveis `.env`
```env
JWT_SECRET=defina-um-segredo-forte
JWT_EXPIRES_IN=15m

Como usar

No arquivo de rotas onde quiser proteção:

import { authenticateJwt } from "../middlewares/auth";
router.get("/me", authenticateJwt, (req, res) => res.json({ me: req.user }));


Para emitir tokens (ex.: após login):

import { signToken } from "../auth/jwt";
const token = signToken({ id: user.id, role: "user" });

Testes

Os testes são mockados (sem serviços externos):

npm test