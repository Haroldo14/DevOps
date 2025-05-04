🎓 Quiz Interactif — Maîtrise de HashiCorp Vault
Ce petit questionnaire servira a vous tester sur Vault


1. Qu’est-ce que le processus de seal/unseal dans Vault ?
 Une méthode de backup
 Un mécanisme de verrouillage/déverrouillage de la barrière de chiffrement
 Une procédure d’installation
 Un type de token

2. Quel composant est responsable du stockage physique des données chiffrées dans Vault ?
 Le Storage Backend
 Le Secret Engine
 Le Policy Store
 L’Audit Device

3. Quelle méthode de chiffrement Vault utilise-t-il par défaut pour protéger les secrets au repos ?
 RSA
 TLS uniquement
 AES-GCM 256 bits
 SHA256

4. Que représente la "Barrier" dans l’architecture de Vault ?
 Une API REST
 Un rôle de sécurité dans Kubernetes
 Une barrière cryptographique protégeant l’accès aux secrets
 Un plugin Vault


5. Quel est le rôle du "Token Store" ?
 Stoker les secrets
 Gérer l’émission et le cycle de vie des tokens
 Appliquer les politiques
 Auditer les actions

6. Parmi ces méthodes d’authentification, laquelle n’est pas native à Vault ?
 AppRole
 Kubernetes
 LDAP
 OAuth2 (géré indirectement via OIDC)

7. Quelle est la différence entre un secret statique et un secret dynamique ?
 Aucun
 Le secret dynamique est généré à la demande et a une durée de vie limitée
 Le secret statique est chiffré dynamiquement
 Le secret dynamique est un alias du statique

8. Quel est le rôle du Policy Store ?
 Définir les permissions d’accès
 Stocker les tokens
 Fournir des logs
 Déterminer les secrets


9. Quelle est la différence entre les permissions read et list dans une politique ?
 read permet de lire un secret, list permet uniquement de voir les clés disponibles
 list donne un accès total, read est restreint
 Aucune
 Elles sont équivalentes

10. Comment Vault s’intègre-t-il à Kubernetes ?
 En installant Vault dans un Pod
 Par injection automatique via le Vault Agent et les annotations de pods
 Avec un CRD
 Vault n’est pas compatible avec Kubernetes

11. Qu’est-ce qu’un lease dans Vault ?
 Un type de politique
 Une durée de validité pour un secret dynamique ou un token
 Une méthode d’auth
 Un backend

12. Quel composant garantit la traçabilité et la conformité dans Vault ?
 Token Store
 Policy Store
 Audit Device
 Secret Engine

13. Comment fonctionne la haute disponibilité (HA) dans Vault ?
 Grâce à un backend HA (comme Raft ou Consul) et à une élection de leader
 Avec un load balancer externe
 Vault ne supporte pas le HA
 Avec Vault Agent uniquement

14. Que permet un snapshot Vault ?
 De créer un token temporaire
 De déverrouiller la barrier
 De sauvegarder l’état du Vault
 De révoquer les tokens expirés