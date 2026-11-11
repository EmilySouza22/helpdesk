# Contrato da API

Base URL: `http://localhost:3000/api`
Autenticação: header `Authorization: Bearer <token>` em todas as rotas, exceto `/auth/login` e `/health`.

## Regras gerais

- O **perfil** e o **id do usuário** vêm do token, nunca do corpo da requisição. O solicitante de um chamado é sempre o usuário logado.
- Toda permissão é validada no servidor.
- Erros sempre no formato `{ "erro": "mensagem para exibir ao usuário" }`.
- Datas trafegam como texto `YYYY-MM-DD HH:mm:ss`.
- Valores fixos (iguais no banco e na API):
  - `perfil`: `Solicitante` | `Tecnico`
  - `prioridade`: `Baixa` | `Media` | `Alta`
  - `status`: `Aberto` | `Em atendimento` | `Finalizado`

## Códigos HTTP

| Código | Quando |
|---|---|
| 200 / 201 | sucesso / criado |
| 400 | validação (campo vazio, valor inválido, data fora do intervalo, solução ausente) |
| 401 | sem token, token inválido, expirado ou revogado (logout) / login inválido |
| 403 | perfil sem permissão, chamado de outro usuário, técnico não é o responsável |
| 404 | recurso não encontrado |
| 409 | conflito de regra de negócio (já tem responsável, já finalizado, não está "Aberto") |

## Rotas

| Método | Rota | Acesso | Descrição |
|---|---|---|---|
| GET | `/health` | público | API e banco no ar |
| POST | `/auth/login` | público | login |
| POST | `/auth/logout` | logado | invalida o token |
| GET | `/auth/me` | logado | usuário logado |
| GET | `/dashboard/contadores` | logado | contagem por status |
| GET | `/categorias` | logado | lista categorias |
| GET | `/chamados?busca=` | logado | lista (solicitante: só os seus; técnico: todos) |
| POST | `/chamados` | logado | abre chamado |
| GET | `/chamados/:id` | logado | detalhes + histórico |
| PUT | `/chamados/:id` | solicitante dono | edita (só "Aberto") |
| DELETE | `/chamados/:id` | solicitante dono | exclui (só "Aberto" e sem histórico) |
| GET | `/atendimento/chamados` | **técnico** | lista do mais antigo ao mais recente |
| POST | `/atendimento/chamados/:id/assumir` | **técnico** | assume chamado "Aberto" sem responsável |
| POST | `/atendimento/chamados/:id/atualizar` | **técnico responsável** | registra observação, data/hora e status |

## Exemplos

### POST /auth/login

```json
// request
{ "email": "ana@empresa.com", "senha": "Senha@123" }

// 200
{
  "token": "eyJhbGciOi...",
  "usuario": { "id": 1, "nome": "Ana Souza", "email": "ana@empresa.com", "perfil": "Solicitante" }
}

// 400 (campo vazio)  -> { "erro": "Informe e-mail e senha" }
// 401 (qualquer falha) -> { "erro": "E-mail ou senha inválidos" }
```

### GET /dashboard/contadores

```json
{ "aberto": 2, "emAtendimento": 2, "finalizado": 1 }
```

### GET /categorias

```json
[ { "id": 1, "nome": "Hardware" }, { "id": 2, "nome": "Software" }, { "id": 3, "nome": "Rede" } ]
```

### GET /chamados?busca=teclado (busca por número ou assunto)

```json
[
  {
    "id": 4,
    "assunto": "Teclado com teclas travando",
    "categoria": "Hardware",
    "prioridade": "Baixa",
    "data_abertura": "2026-10-28 08:45:00",
    "status": "Finalizado"
  }
]
```

### POST /chamados

```json
// request (solicitante, status e data são definidos pelo servidor)
{ "assunto": "Mouse sem funcionar", "descricao": "O mouse não responde.", "categoria_id": 1, "prioridade": "Baixa" }

// 201
{ "id": 6, "status": "Aberto", "data_abertura": "2026-11-10 10:00:00" }
```

### GET /chamados/:id

```json
{
  "id": 4,
  "assunto": "Teclado com teclas travando",
  "descricao": "Várias teclas ...",
  "categoria": "Hardware",
  "prioridade": "Baixa",
  "solicitante": { "id": 2, "nome": "Bruno Lima" },
  "tecnico": { "id": 4, "nome": "Diego Rocha" },
  "data_abertura": "2026-10-28 08:45:00",
  "status": "Finalizado",
  "historico": [
    { "id": 2, "tecnico": "Diego Rocha", "data_hora": "2026-10-28 09:00:00", "observacao": "Chamado assumido pelo técnico.", "solucao": null, "status_resultante": "Em atendimento" }
  ]
}
```

`tecnico` é `null` enquanto ninguém assumiu.

### PUT /chamados/:id

Corpo igual ao do POST. 409 se o status não for "Aberto"; 403 se o chamado não for do usuário.

### DELETE /chamados/:id

409 se o status não for "Aberto" ou se já houver histórico; 403 se não for do usuário.

### POST /atendimento/chamados/:id/assumir

Sem corpo. Define o técnico logado como responsável, status "Em atendimento" e grava um registro no histórico.
409 se o chamado já tem responsável ou não está "Aberto".

### POST /atendimento/chamados/:id/atualizar

```json
{
  "data_hora": "2026-11-10 10:30:00",
  "observacao": "Peça solicitada ao fornecedor.",
  "solucao": null,
  "status": "Em atendimento"
}
```

Para finalizar: `"status": "Finalizado"` e `solucao` obrigatória.

Ordem das verificações no servidor:

1. chamado existe? (404)
2. já está "Finalizado"? (409)
3. técnico logado é o responsável? (403)
4. `data_hora` >= abertura e <= agora? (400)
5. finalizando sem `solucao`? (400)

## Telas x rotas (para o frontend)

| Tela | Rotas usadas |
|---|---|
| Login | POST `/auth/login` |
| Principal | GET `/auth/me`, GET `/dashboard/contadores`, POST `/auth/logout` |
| Abertura e consulta | GET `/chamados`, GET `/categorias`, POST/PUT/DELETE `/chamados`, GET `/chamados/:id` |
| Atendimento (só técnico) | GET `/atendimento/chamados`, POST `/atendimento/chamados/:id/assumir`, POST `/atendimento/chamados/:id/atualizar`, GET `/chamados/:id` |
