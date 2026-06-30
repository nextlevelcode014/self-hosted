# SearXNG

Motor de busca meta auto-hospedado, privado e customizável.

## Serviços

| Serviço | Imagem | Função |
|---|---|---|
| `searxng-core` | `searxng/searxng` | Motor de busca |
| `searxng-valkey` | `valkey/valkey:9-alpine` | Cache (Redis-compatible) |

## Acesso

- `http://localhost:${SEARXNG_PORT:-8080}`

## Config

```bash
cp .env.example .env
# Editar SEARXNG_PORT, SEARXNG_HOST, etc.
```

Configurações customizadas do SearXNG vão em `core-config/settings.yml`.

## Uso

```bash
docker compose up -d
docker compose down
```

## Volumes

| Volume | Mount |
|---|---|
| `core-data` | `/var/cache/searxng/` |
| `valkey-data` | `/data/` |
| `core-config/` | `/etc/searxng/` (bind mount) |

## Atualizar

```bash
docker compose down
docker compose pull
docker compose up -d
```

## Docs

- [Documentação oficial](https://docs.searxng.org/)
- [Instalação Docker](https://docs.searxng.org/admin/installation-docker.html)
