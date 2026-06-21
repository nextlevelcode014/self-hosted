# Nextcloud AIO

Nextcloud All-In-One — sincronização de arquivos, Talk (videochamadas) e Collabora (escritório).

## Serviços

| Serviço | Função |
|---|---|
| `nextcloud-aio-mastercontainer` | Orquestrador AIO |
| `coturn` | TURN/STUN para Nextcloud Talk |

## Acesso

- Painel AIO: `http://localhost:8080`
- Nextcloud: `http://localhost:11000` (atrás de reverse proxy)

## Config

```bash
cp .env.example .env
# Editar TURN_RELAY_IP e TURN_SECRET
```

## Uso

```bash
docker compose up -d
```

## Workers de IA

Para processamento de tarefas de IA (tradução, imagens):

```bash
# systemd service
sudo cp nextcloud-ai-worker@.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now nextcloud-ai-worker@1
```

## Reset

```bash
bash reset.sh
```
