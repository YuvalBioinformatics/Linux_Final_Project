#!/bin/bash

LOG_FILE=$HOME/Work_Course_Linux/5Q/docker_log.txt
echo "[INFO] Logging container file contents..." > "$LOG_FILE"

for container in container_1 container_2; do
    echo "[INFO] Container: $container" >> "$LOG_FILE"
    docker exec "$container" ls -lah /app >> "$LOG_FILE"
    echo "------------------------------------" >> "$LOG_FILE"
done

echo "[INFO] Log created at: $LOG_FILE"
