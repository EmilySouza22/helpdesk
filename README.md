# Helpdesk - Sistema de Chamados

Atividade Prática SENAI - Turma DESI 2025/1 N1.
Sistema web para abertura, consulta, atendimento e finalização de chamados de suporte técnico.

**Tecnologias:** Node.js, Express, MySQL (mysql2), bcrypt, jsonwebtoken, cors, dotenv, React (Vite), Axios, React Router.

## Estrutura

```
/
├── README.md
├── helpdesk_db.sql          script de criação e população do banco
├── DER.png                  (a ser adicionado)
├── documentation/           requisitos, casos de teste, contrato da API
├── montar-zip.sh            monta a pasta de entrega
└── sistema/
    ├── backend/             API (Node + Express)
    └── frontend/            interface (React + Vite)
```

## Pré-requisitos

- Node.js **20.19+** (ou 22.12+) e npm
- MySQL **8.0+**
- Git

## Como rodar

### 1. Banco de dados

Na raiz do projeto:

```bash
mysql -u root -p < helpdesk_db.sql
```

Isso recria o banco `helpdesk_db` do zero, com as tabelas e os dados de teste.
Alternativa: abrir o arquivo no MySQL Workbench e executar tudo.

### 2. Backend

```bash
cd sistema/backend
cp .env.example .env      # no Windows: copy .env.example .env
```

Abra o `.env` e preencha `DB_USER`, `DB_PASSWORD` e `JWT_SECRET`. Depois:

```bash
npm install
npm run dev
```

A API sobe em `http://localhost:3000`. Teste: `http://localhost:3000/api/health` deve responder `{"status":"ok","api":"ok","banco":"ok"}`.

> Se o `npm install` falhar no `bcrypt` (comum no Windows), troque por `bcryptjs`:
> `npm uninstall bcrypt && npm install bcryptjs` e use `require('bcryptjs')`.

### 3. Frontend (em outro terminal)

```bash
cd sistema/frontend
cp .env.example .env
npm install
npm run dev
```

Abra `http://localhost:5173`. A página inicial deve mostrar "Front, API e banco conversando".

## Logins de teste

Senha de todos: `Senha@123`

| Nome | E-mail | Perfil |
|---|---|---|
| Ana Souza | ana@empresa.com | Solicitante |
| Bruno Lima | bruno@empresa.com | Solicitante |
| Carla Mendes | carla@empresa.com | Técnico |
| Diego Rocha | diego@empresa.com | Técnico |

Para gerar o hash de uma nova senha: `cd sistema/backend && npm run hash -- MinhaSenha`.

## Fluxo de trabalho (Git)

- A `main` está protegida: **nada de commit direto**, só por Pull Request com revisão da outra pessoa.
- Cada tarefa em uma branch: `feat/login`, `feat/lista-chamados`, `feat/atendimento`...
- Commits pequenos, com mensagem clara (`feat:`, `fix:`, `docs:`).
- Se mudar o banco, atualize o `helpdesk_db.sql` **e avise a outra pessoa**.
- O contrato da API está em `documentation/contrato-api.md`. Mudou algo? Atualize o contrato no mesmo PR.
- Divisão de tarefas: `documentation/divisao-de-tarefas.md`.
