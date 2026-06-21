# AdGuard Home

DNS-level ad-blocking and network-wide tracker blocking.

## Services

| Service | Image | Purpose |
|---|---|---|
| `adguardhome` | `adguard/adguardhome:latest` | DNS sinkhole, DHCP server |

## Acesso

`https://adguard.<TAILNET>.ts.net`

## Config

- `./adguard/work/` — dados de trabalho
- `./adguard/conf/` — configuração

## Uso

```bash
docker compose up -d
```
