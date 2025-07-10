#!/bin/bash

SOURCE="/c/Users/Haroldopc/Project_DevOps/devops-homelab"
DEST_BASE="/h/Backups"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
DEST="$DEST_BASE/$TIMESTAMP"
LOG_DIR="./logs"
LOG_FILE="$LOG_DIR/sauvegarde.log"

mkdir -p "$LOG_DIR"



echo "[$(date '+%Y-%m-%d_%H-%M-%S')] Lancement de la sauvegarde " >> "$LOG_FILE"
echo "Source: $SOURCE" >> "$LOG_FILE"

START_TIME=$(date -u "+%s")
mkdir -p "$DEST"

SECONDS=0
if cp -r "$SOURCE" "$DEST" 2>> "$LOG_FILE"; then
    END_TIME=$(date -u + "%s")
    #DURATION=$((END_TIME-START_TIME))
    DURATION=$SECONDS
    echo "Destination: $DEST" >> "$LOG_FILE"
    echo "Sauvegarde reussie en $DURATION secondes." >> "$LOG_FILE"

    MSG="Sauvegarde reussie vers $DEST"
    powershell.exe -Command "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('$MSG','Sauvegarde automatique')"
else
    echo "Erreur lors de la sauvegarde !" >> "$LOG_FILE"
    MSG="Echec de la sauvegarde. Verifiez le log."
    powershell.exe -Command "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('$MSG','Erreur sauvegarde')"
fi

echo "-----------------------------" >> "$LOG_FILE"