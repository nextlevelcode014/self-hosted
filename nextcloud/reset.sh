#!/usr/bin/env bash

set -euo pipefail

echo "=== RESET NEXTCLOUD AIO ==="

# 1. Stop mastercontainer
echo "-> Stopping nextcloud-aio-mastercontainer (if running)"
sudo docker stop nextcloud-aio-mastercontainer 2>/dev/null || true

# 2. Stop domaincheck container if running
echo "-> Stopping nextcloud-aio-domaincheck (if running)"
sudo docker stop nextcloud-aio-domaincheck 2>/dev/null || true

# 3. Stop any remaining AIO containers
echo "-> Checking for remaining nextcloud-aio containers"
AIO_CONTAINERS=$(sudo docker ps --format '{{.Names}}' | grep nextcloud-aio || true)

if [ -n "$AIO_CONTAINERS" ]; then
  echo "$AIO_CONTAINERS" | while read -r container; do
    echo "   Stopping $container"
    sudo docker stop "$container"
  done
else
  echo "   No running AIO containers found"
fi

# 4. Show exited containers
echo "-> Exited containers:"
sudo docker ps --filter "status=exited"

# 5. Remove stopped containers
echo "-> Pruning stopped containers"
sudo docker container prune -f

# 6. Remove AIO network
echo "-> Removing nextcloud-aio network (if exists)"
sudo docker network rm nextcloud-aio 2>/dev/null || true

# 7. Remove nextcloud-aio volumes
echo "-> Removing nextcloud-aio volumes"
AIO_VOLUMES=$(sudo docker volume ls --format '{{.Name}}' | grep nextcloud || true)

if [ -n "$AIO_VOLUMES" ]; then
  echo "$AIO_VOLUMES" | while read -r volume; do
    echo "   Removing volume $volume"
    sudo docker volume rm "$volume"
  done
else
  echo "   No Nextcloud AIO volumes remaining"
fi

# 10. Optional: prune all images
read -p "Do you want to remove ALL docker images? (y/N): " REMOVE_IMAGES
if [[ "$REMOVE_IMAGES" =~ ^[Yy]$ ]]; then
  echo "-> Removing all docker images"
  sudo docker image prune -a -f
else
  echo "-> Skipping image removal"
fi

echo "=== RESET COMPLETED ==="
echo "You can now start over with the recommended docker run command."
