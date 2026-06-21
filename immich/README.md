# Immich

Gerenciador de fotos e vídeos auto-hospedado, alternativa ao Google Photos.

## Serviços

| Serviço | Imagem | Função |
|---|---|---|
| `immich-server` | `immich-server` | Servidor principal e API |
| `immich-machine-learning` | `immich-machine-learning` | Reconhecimento facial e ML |
| `redis` | `valkey` | Cache |
| `database` | `postgres` | Banco de dados |
| `tailscale` | `tailscale/tailscale` | Sidecar Tailscale |

## Acesso

`https://immich.<TAILNET>.ts.net`

## Config

```bash
cp .env.example .env
# Editar TS_AUTHKEY, DB_PASSWORD, DB_USERNAME, DB_DATABASE_NAME, UPLOAD_LOCATION, DB_DATA_LOCATION
```

## Uso

```bash
docker compose up -d
```
