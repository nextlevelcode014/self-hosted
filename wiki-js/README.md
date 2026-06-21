# Wiki.js

Plataforma de wiki moderna e open-source.

## Serviços

| Serviço | Imagem | Função |
|---|---|---|
| `db` | `postgres:15-alpine` | Banco de dados PostgreSQL |
| `wiki` | `ghcr.io/requarks/wiki:2` | Servidor Wiki.js |

## Acesso

`https://wiki.<TAILNET>.ts.net`

## Config

```bash
cp .env.example .env
# Editar DB_USER e DB_PASS
```

## Uso

```bash
docker compose up -d
```
