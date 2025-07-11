import os               # export les listes et chemins des fichiers
import shutil           # gestion des dossiers(deplacement/suppression)
import logging          # gestion des logs
from datetime import datetime, timedelta    # gestion des dates
from dotenv import load_dotenv              # module externe permettant d'appeler des variables depuis un fichier .env  
import argparse         # gestion des arguments pour l'execution

# Load environment variables
load_dotenv()           # va recuperer nos variables creer dans le .env a la racine de notre projet

SOURCE_DIR = os.getenv("SOURCE_DIR") # appel de la variable qui definit le dossier a sauvegarder
BACKUP_DIR = os.getenv("BACKUP_DIR") # appel de la variable qui definit le dossier de sauvegarde
RETENTION_DAYS = int(os.getenv("RETENTION_DAYS", 7)) # appel de la varaible de temps de conservation de la sauvegarde avec duree par defaut si absente

# Configure logging
log_dir = "logs"
os.makedirs(log_dir, exist_ok=True) # creation dossier logs s'il n'existe pas
logging.basicConfig(
    filename=os.path.join(log_dir, "backup.log"),  # definit nom des logs
    level=logging.INFO,             # sauvegarde des informations au format decrit en dessous
    format="%(asctime)s - %(levelname)s - %(message)s"
)

def copy_files():
    """Copie les fichiers du dossier source vers le dossier de backup."""
    if not os.path.exists(SOURCE_DIR):
        logging.error(f"Source folder not found: {SOURCE_DIR}")
        return

    backup_subfolder = os.path.join(BACKUP_DIR, datetime.now().strftime("%Y-%m-%d_%H-%M-%S"))
    os.makedirs(backup_subfolder, exist_ok=True)  # permet de creer un dossier avec toute sa hierachie meme si dossier parent inexistant

    for root, _, files in os.walk(SOURCE_DIR):   # inspecte minisieusement le dossier et sous-dossier
        for file in files:
            source_file = os.path.join(root, file)
            relative_path = os.path.relpath(root, SOURCE_DIR)
            dest_dir = os.path.join(backup_subfolder, relative_path)
            os.makedirs(dest_dir, exist_ok=True) # Creer les sous-dossiers necessaires 
            shutil.copy2(source_file, os.path.join(dest_dir, file)) # Copie chaque elements en conservant ses metadonnees

    logging.info(f"Backup completed: {backup_subfolder}") # Enregistre dans les logs un message de resussite de la sauvegarde

def clean_old_backups():
    """Supprime les anciens dossiers de sauvegarde selon la rétention définie."""
    now = datetime.now()
    for folder in os.listdir(BACKUP_DIR):
        folder_path = os.path.join(BACKUP_DIR, folder)
        if os.path.isdir(folder_path):
            try:
                folder_time = datetime.strptime(folder, "%Y-%m-%d_%H-%M-%S")
                if now - folder_time > timedelta(days=RETENTION_DAYS):
                    shutil.rmtree(folder_path)
                    logging.info(f"Deleted old backup: {folder_path}")
            except ValueError:
                pass  # ignore les dossiers de sauvegarde dont le nom ne respecte pas le format definit

def main():
    parser = argparse.ArgumentParser(description="Automated Backup Tool")
    parser.add_argument("--backup", action="store_true", help="Run backup now")
    parser.add_argument("--clean", action="store_true", help="Clean old backups")

    args = parser.parse_args()

    if args.backup:
        copy_files()
    if args.clean:
        clean_old_backups()
    if not args.backup and not args.clean:
        parser.print_help()

if __name__ == "__main__":
    main()
