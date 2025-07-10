# Sauvegarde automatique
Script Bash + Windows PowerShell
Ce projet permet tout simplement de sauvegarder automatiquement un dossier dans une archive compresee avec horodatage pour se reperer facilement.

# Fonctionnalites
- Utilisation de la compression en 'tar.gz'
- Ajout automatique lors de la sauvegarde de l'heure dans le nom de celle-ci
- Execution manuelle ou de maniere automatique avec 'Task scheduler' de windows. (Pour linux ca sera avec 'cron')

### Utilisation
Apres verification des droits executer simplement la commande
```bash
./backup.sh
```