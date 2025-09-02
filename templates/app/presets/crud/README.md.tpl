# {{projectName}} (Preset: CRUD)

Endpoints:
- `GET /api/users`
- `GET /api/users/:id`
- `POST /api/users` — `{ name, email }`
- `PUT /api/users/:id` — `{ name?, email? }`
- `DELETE /api/users/:id`

Rode os testes:
```bash
npm test
npm run test:coverage
