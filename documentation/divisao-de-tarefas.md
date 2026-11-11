# Divisão de tarefas

- **Backend** (Node, Express, MySQL): Emily Afonso
- **Frontend** (React): Alice Cotrim
- **Em conjunto:** requisitos funcionais, DER, casos de teste e revisão dos PRs

Como o frontend depende da API, a ordem de entrega do backend define o ritmo. Enquanto uma rota não existe, o frontend monta a tela com dados de exemplo seguindo o formato do `contrato-api.md`.

## Backend

1. Middleware `autenticar` (JWT) e `exigirTecnico`
2. `POST /auth/login`, `GET /auth/me`, `POST /auth/logout` (revogação do token via `jti`)
3. `GET /dashboard/contadores` e `GET /categorias`
4. CRUD de chamados (`/chamados`) com as regras de dono e status "Aberto"
5. Atendimento: listar (com algoritmo de ordenação próprio em `utils/ordenacao.js`), assumir, atualizar e finalizar
6. Manter o `helpdesk_db.sql` e o contrato da API atualizados

## Frontend 

1. Layout base, `AuthContext`, interceptors do axios (token e tratamento de 401) e `RotaPrivada`
2. Tela de login (validação de campos, mensagem "E-mail ou senha inválidos")
3. Tela principal (nome e perfil, logout, contadores, links para as telas 6 e 7)
4. Tela de abertura e consulta de chamados: tabela, busca, formulário de criar/editar, exclusão com confirmação, detalhes e histórico, botão de voltar
5. Tela de atendimento (só técnico): lista, detalhes, assumir, observação, campo de data e hora (`datetime-local` iniciando no momento atual), finalizar, alertas, botão de voltar

## Em conjunto

1. Lista de requisitos funcionais (RF01, RF02...)
2. DER (`DER.png`)
3. Casos de teste, cobrindo os 14 cenários do item 8.3 do enunciado, com condições iniciais, passos, dados, resultado esperado e resultado obtido
4. Montagem do `documentacao_helpdesk.pdf` e do zip final
5. Revisão cruzada de cada Pull Request
