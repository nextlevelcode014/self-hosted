# AdGuard Home

DNS-level ad-blocking and network-wide tracker blocking.

## Serviços

| Serviço | Imagem | Função |
|---|---|---|
| `adguardhome` | `adguard/adguardhome:latest` | DNS sinkhole, DHCP server |
| `tailscale-adguard` | `tailscale/tailscale:latest` | Sidecar Tailscale |

## Acesso

`https://adguard.<TAILNET>.ts.net`

## Config

- `./work/` — dados de trabalho
- `./conf/` — configuração

## Uso

```bash
docker compose up -d
```
