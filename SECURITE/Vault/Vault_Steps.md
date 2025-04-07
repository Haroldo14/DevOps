# Mise en Place de HashiCorp Vault dans un Cluster Kubernetes

## Introduction
Ce guide couvre l'installation et la configuration de HashiCorp Vault dans un cluster Kubernetes, ainsi que la récupération dynamique de secrets par une application.

---
Autocompletion commandes K8s
source <(kubectl completion bash)
kubectl completion bash > $HOME/.kube/completion.bash.inc
echo "source $HOME/.kube/completion.bash.inc" >> $HOME/.bash_profile
source $HOME/.bash_profile

## Installation de Helm
```bash
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version
helm repo add stable https://charts.helm.sh/stable
helm repo update
```

## Installation de Vault via Helm
```bash
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
kubectl create ns vault-ns
helm install vault hashicorp/vault --set "server.dev.enabled=true"  # Sans injector
helm install vault hashicorp/vault --set "server.dev.enabled=true" --set "injector.enabled=true" -n vault-ns # Avec injector
kubectl get pods -n vault-ns | grep -i vault
```

## Configuration de Vault

### Vérifier l'initialisation de Vault
```bash
kubectl exec -it -n vault-ns vault-0 -- vault status
```
![Status Vault](images/photo_1.png)

### Initialisation de Vault
```bash
kubectl exec -it -n vault-ns vault-0 -- /bin/sh
vault operator init
```

### Récupération des clés d'initialisation (si déjà initialisé et verrouillé)
```bash
kubectl logs -n vault-ns vault-0 | grep 'Unseal Key'
```
![Clés de déverrouillage](images/Screenshot_2025-03-24_191616.png)

Déverrouillage de Vault :
```bash
kubectl exec -it -n vault-ns vault-0 -- vault operator unseal <clé_1>
```
![Utilisation clé](images/photo_2.png)

## Gestion des Secrets dans Vault
```bash
vault secrets enable kv  # Activation du moteur de secrets
vault secrets list       # Verification des moteurs de secrets activer
kubectl exec -it -n vault-ns vault-0 -- /bin/sh
vault kv put kv/myapp username="haroldo" password="DevOps100000$"  # Création d'un secret
vault kv get kv/myapp  # Récupération d'un secret
```
![Activation du moteur de secrets](images/photo_4.png)
![Création/Récupération secret](images/Screenshot_2025-03-24_203832.png)

## Configuration pour Kubernetes

### Activation de l'authentification Kubernetes
```bash
kubectl exec -it -n vault-ns vault-0 -- vault auth enable kubernetes
```
![Authentification via K8s activée](images/photo_3.png)

### Configuration de l'authentification Kubernetes
```bash
vault write auth/kubernetes/config \
  token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
  kubernetes_host="https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT" \
  kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
```
![Illustration](images/photo_7.png)

### Définition d'une politique Vault
```bash
vault policy write my-policy - <<EOF
path "kv/myapp" {
  capabilities = ["read"]  
}
EOF        # create/update/delete/list/sudo/deny
```
![policy](<images/Screenshot 2025-03-24 204350.png>)



Vérification via le conteneur Vault :
```bash
kubectl exec -it -n vault-ns vault-0 -- sh
vault policy list
vault policy read my-policy
```
![Vérification Policy existante](images/Screenshot_2025-03-24_193421.png)

### Création d'un rôle pour les Pods Kubernetes
```bash
vault write auth/kubernetes/role/myapp \
  bound_service_account_names=vault-sa \
  bound_service_account_namespaces=vault-ns \
  policies=my-policy \
  ttl=24h
```
![Rôle](images/Screenshot_2025-03-24_204457.png)

### Création du ServiceAccount pour Vault
```bash
kubectl create sa vault-sa -n vault-ns
```

### Déploiement du client Vault
```bash
kubectl apply -f vault-client.yaml -n vault-ns
```

## Récupération d'un Secret depuis Vault
```bash
kubectl exec -it -n vault-ns vault-client -- sh
curl -s --request GET --header "X-Vault-Token: <TON_TOKEN_ROOT>" http://vault:8200/v1/kv/myapp | jq  # Dans mon cas TOKEN_ROOT = root
```
![Récupération Secret via Pod](images/Screenshot_2025-03-24_204841.png)

## Ajout de Vault Agent Injector
Ajoutons Vault Agent Injector pour injecter dynamiquement les secrets dans les Pods sans exposer directement les tokens.

### Modification de l'installation Helm pour inclure l'Injector
```bash
helm upgrade --install vault hashicorp/vault --set "server.dev.enabled=true" --set "injector.enabled=true" -n vault-ns
```

### Exemple de Pod utilisant Vault Agent Injector
Déploiement du Pod :
```bash
kubectl apply -f vault-injector-example.yaml -n vault-ns
```
Verification injection Secret
```bash
kubectl logs myapp -n vault-ns -c vault-agent
```
```bash
kubectl exec -it -n vault-ns myapp -- cat /vau
lt/secrets/config.txt
```


### Utilisation de Vault pour la rotation automatique des mots de passe d'une base de données. 
```bash
kubectl exec -it -n vault-ns vault-0 -- vault plugin list
```
```bash
kubectl run postgres --image=postgres:15 -n vault-ns --env="POSTGRES_PASSWORD=my_100000$" --env="POSTGRES_USER=DevOp_Int"
```
kubectl exec -it postgres -n vault-ns -- psql -U DevOp_Int


```bash
kubectl expose pod postgres --name=postgres --port=5432 --target-port=5432 -n vault-ns
```
```bash
kubectl exec -it -n vault-ns vault-0 -- /bin/sh
vault secrets enable database
```
```bash
vault write database/config/postgres \
    plugin_name=postgresql-database-plugin \
    allowed_roles="db-role" \
    connection_url="postgresql://{{username}}:{{password}}@postgres.vault-ns.svc.cluster.local:5432/postgres?sslmode=disable" \
    username="DevOp_Int" \
    password="my_100000$"
```

```bash
vault list database/config
```

```bash
vault write database/roles/db-role \
    db_name=postgres \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
    default_ttl="1h" \
    max_ttl="24h"
```

```bash
vault list database/roles
```

```bash
vault read database/creds/db-role
```
Changement mot de passe acces db
```bash
vault write -force database/rotate-root/postgres
```

## Nettoyage de l'installation
Pour supprimer proprement Vault du cluster :
```bash
helm uninstall vault -n vault-ns
kubectl delete namespace vault-ns
```

---

## Conclusion
Ce guide a couvert l’installation et l’utilisation de HashiCorp Vault dans Kubernetes, en expliquant comment stocker et récupérer des secrets de manière sécurisée. L’ajout de Vault Agent Injector permet une intégration plus fluide des secrets sans exposer directement les tokens.

---

