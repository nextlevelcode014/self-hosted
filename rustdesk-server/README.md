# RustDesk Server

Servidor de acesso remoto auto-hospedado, alternativa ao TeamViewer/AnyDesk.

## Serviços

| Serviço | Imagem | Função |
|---|---|---|
| `hbbs` | `rustdesk/rustdesk-server` | Rendezvous / ID server |
| `hbbr` | `rustdesk/rustdesk-server` | Relay server |
| `tailscale` | `tailscale/tailscale` | Sidecar Tailscale |

## Acesso

Apenas via Tailscale. O servidor responde em `rustdesk.<TAILNET>.ts.net` nas portas `21115`-`21119`.

## Config

```bash
cp .env.example .env
# Editar TS_AUTHKEY
```

## Uso

```bash
docker compose up -d
```

## Clients

No cliente RustDesk, configurar:

- **ID Server**: `rustdesk.<TAILNET>.ts.net`
- **Relay Server**: `rustdesk.<TAILNET>.ts.net:21117`
- **Key**: obtida em `./data/id_ed25519.pub`

O cliente precisa estar na mesma tailnet.
