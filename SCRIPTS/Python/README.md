# Outil d'automatisation en python

Un outil d'automatisation des sauvegardes écrit en Python, simple, extensible et prêt pour la production. Il permet :

- De copier tous les fichiers d’un répertoire source vers un dossier de sauvegarde horodaté.
- De supprimer automatiquement les anciennes sauvegardes selon une durée de rétention configurable.
- D’utiliser des arguments CLI (--backup, --clean) pour s'intégrer facilement dans un cron job ou script DevOps.

---

## Fonctionnalités et Fonctions

- Permet la sauvegarde des fichiers avec conservation de l'arborescence des fichiers.
- Permet le Nettoyage automatique des anciennes sauvegardes selon une rétention (dans notre cas 3 jours).
- Utilisation de variables d’environnement via .env.
- Enregistrement de Log complet des opérations dans un fichier backup.log.

---

## Necessaire

- Python 3.6+
- Le package python-dotenv (installable via pip)
```bash
pip install python-dotenv
```

## Utilisation 
```bash
# Donne toute les informations necessaires
python backup.py 
```