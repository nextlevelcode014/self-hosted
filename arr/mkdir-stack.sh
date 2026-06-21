#!/usr/bin/env bash

# Cria toda a estrutura de diretórios da media stack
# Execute com: bash mkdir-stack.sh

set -euo pipefail

BASE="/opt/media-stack"

echo "Criando estrutura em $BASE..."

mkdir -p \
  $BASE/config/qbittorrent \
  $BASE/config/radarr \
  $BASE/config/sonarr \
  $BASE/config/prowlarr \
  $BASE/config/bazarr \
  $BASE/config/profilarr \
  $BASE/config/decluttarr \
  $BASE/config/lidarr \
  $BASE/data/torrents/movies \
  $BASE/data/torrents/tv \
  $BASE/data/torrents/anime \
  $BASE/data/torrents/music \
  $BASE/data/media/movies \
  $BASE/data/media/tv \
  $BASE/data/media/anime \
  $BASE/data/media/music \
  /opt/jellyfin/config \
  /opt/jellyfin/cache \
  /opt/jellyseerr/config

# Ajusta permissões para PUID/PGID 1000
sudo chown -R 1000:1000 $BASE /opt/jellyfin /opt/jellyseerr
sudo chmod -R 775 $BASE /opt/jellyfin /opt/jellyseerr

echo "Pronto! Estrutura criada:"
find $BASE /opt/jellyfin /opt/jellyseerr -type d | sort
