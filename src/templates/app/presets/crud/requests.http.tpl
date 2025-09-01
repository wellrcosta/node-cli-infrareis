### Healthcheck
GET http://localhost:3000/health
Accept: application/json


### Listar usuários
GET http://localhost:3000/api/users
Accept: application/json


### Criar usuário
POST http://localhost:3000/api/users
Content-Type: application/json

{
  "name": "Ana",
  "email": "ana@example.com"
}


### Buscar usuário por ID
# substitua <id> pelo ID retornado no POST
GET http://localhost:3000/api/users/<id>
Accept: application/json


### Atualizar usuário
# substitua <id> pelo ID retornado no POST
PUT http://localhost:3000/api/users/<id>
Content-Type: application/json

{
  "name": "Ana Maria"
}


### Excluir usuário
# substitua <id> pelo ID retornado no POST
DELETE http://localhost:3000/api/users/<id>
