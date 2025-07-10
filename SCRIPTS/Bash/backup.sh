#!/bin/bash


SOURCE_DIR="/c/Users/Haroldopc/Project_DevOps/devops-homelab"
BACKUP_DIR="/c/Users/Haroldopc/Documents"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_NAME="Sauvegarde_$DATE.tar.gz"

mkdir -p "$BACKUP_DIR"

tar -czf "$BACKUP_DIR/$BACKUP_NAME" "$SOURCE_DIR"

echo "Sauvegarde de $SOURCE_DIR cree a $BACKUP_DIR/$BACKUP_NAME"