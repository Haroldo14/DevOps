# 1. Mise à jour du système
`sudo apt update && sudo apt upgrade -y`

# 2. Installation de Java 17
`sudo apt install -y fontconfig openjdk-17-jre`
`java -version`

# 3. Ajouter la clé et le dépôt Jenkins
```bash
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \ /usr/share/keyrings jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \https://pkg.jenkins.io/debian binary/" | sudo tee \ /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update```


# 4. Installer Jenkins
`sudo apt install -y jenkins`

# 5. Activer et démarrer Jenkins
`sudo systemctl enable --now jenkins`
`sudo systemctl status jenkins`

# 6. Ouvrir le port 8080
`sudo ufw allow 8080/tcp`
`sudo ufw enable`

# 7. Récupérer le mot de passe admin Jenkins
`sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
