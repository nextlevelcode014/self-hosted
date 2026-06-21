# Arr Stack — Media Download & Streaming

Stack completo de gerenciamento e download automático de mídia, roteado via VPN (ProtonVPN) e exposto via Tailscale.

## Serviços

| Serviço | Função |
|---|---|
| **Gluetun** | Cliente WireGuard (ProtonVPN) |
| **qBittorrent** | Cliente de torrent |
| **Prowlarr** | Gerenciador de indexadores |
| **Flaresolverr** | Bypass Cloudflare |
| **Sonarr** | Gerenciamento de séries |
| **Radarr** | Gerenciamento de filmes |
| **Lidarr** | Gerenciamento de música |
| **Bazarr** | Legendas automáticas |
| **Profilarr** | Perfis de qualidade |
| **Jellyfin** | Servidor de mídia |
| **Jellyseerr** | Sistema de requests |
| **Decluttarr** | Limpeza da fila de downloads |
| **Dozzle** | Visualizador de logs Docker |

## Acesso

Cada serviço em `https://<app>.<TAILNET>.ts.net`

## Pré-requisitos

```bash
# Criar diretórios do host
bash mkdir-stack.sh

# Configurar .env
cp .env.example .env
# Editar .env com TS_AUTHKEY
```

## Uso

```bash
docker compose -f docker-compose.media-stack.yml up -d
```

## Diretórios

- `/mnt/media-stack/config/<app>/` — config por app
- `/mnt/media-stack/data/torrents/` — downloads
- `/mnt/media-stack/data/media/` — mídia organizada
