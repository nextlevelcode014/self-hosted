#!/bin/bash
docker compose down

datestamp=$(date +%m-%d-%Y)
backup_dir="/caminho/para/backups"

7z a -p"SUA_SENHA_AQUI" -mhe=on "${backup_dir}/${datestamp}.7z" /caminho/para/vw-data/

scp -P 2222 -i ~/.ssh/sua_chave "${backup_dir}/${datestamp}.7z" usuario@10.0.0.1:/caminho/destino

scp -o ConnectTimeout=15 "${backup_dir}/${datestamp}.7z" usuario@10.0.0.2:/caminho/destino

docker compose up -d

find "${backup_dir}" -type f \( -name '*.7z' -o -name '*.zip' \) -mtime +7 -exec rm {} +
echo "[$(date)] Backup concluído e cleanup feito." >>/caminho/para/backup.log
