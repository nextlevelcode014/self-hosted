# Vaultwarden

Gerenciador de senhas leve e compatível com Bitwarden.

## Serviços

| Serviço | Imagem | Função |
|---|---|---|
| `vaultwarden` | `vaultwarden/server:latest` | Servidor de senhas |

## Acesso

`https://vaultwarden.<TAILNET>.ts.net`

## Config

```bash
cp .env.example .env
# Editar ADMIN_TOKEN
```

Cadastro de novos usuários desabilitado (`SIGNUPS_ALLOWED=false`).

## Backup

O script `transfer_vaultwarden_logs.sh` faz backup automático dos dados do Vaultwarden.

### Lógica

1. Para o stack com `docker compose down`
2. Gera um archive `.7z` criptografado (AES-256) do diretório `vw-data/`
3. Envia via SCP para dois destinos:
   - **Servidor 1:** `10.0.0.1` — porta 2222, chave SSH
   - **Servidor 2:** `10.0.0.2` — usuário `usuario`
4. Sobe o stack novamente com `docker compose up -d`
5. Remove backups mais antigos que 7 dias

### Como usar

```bash
# Backup manual
bash transfer_vaultwarden_logs.sh

# Agendar no crontab (ex.: diário às 03h)
0 3 * * * /caminho/para/transfer_vaultwarden_logs.sh
```

### Restaurar

```bash
# Parar o container
docker compose down

# Extrair o backup
7z x -p"SENHA" /caminho/do/backup.7z

# Substituir ./vw-data/ com os dados extraídos
# Iniciar novamente
docker compose up -d
```
