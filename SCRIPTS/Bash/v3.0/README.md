# Sauvegarde automatique avec gestion des logs

Ce projet permet tout simplement de sauvegarder automatiquement un dossier dans une archive compresee avec horodatage pour se reperer facilement tout en utilisant Git Bash pour l'execution et PowerShell pour afficher une notificatoin de confirmation via une MessageBox et un suivit des logs indiquant l'heure et la duree de la sauvegarde.

# Fonctionnalites
- Ajout automatique lors de la sauvegarde de l'heure dans le nom de celle-ci
- Execution manuelle ou de maniere automatique avec 'Task scheduler' de windows. (Pour linux ca sera avec 'cron')
- Confirmation via une fenetre de MessageBox
- Creation log pour indiquer la date, l'objet de la sauvegarde, l'etat et la duree de celle-ci 

### Utilisation
Apres verification des droits executer simplement la commande
```bash
./backup.sh
```