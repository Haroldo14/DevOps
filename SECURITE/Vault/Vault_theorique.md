# Présentation HashiCorp Vault

## Introduction
HashiCorp Vault est une solution open-source dédiée à la gestion des secrets, développée par HashiCorp. Elle est largement utilisée dans les environnements cloud et Kubernetes pour sécuriser les informations sensibles telles que les clés API, les mots de passe et les certificats.

Lien documentation officielle: https://developer.hashicorp.com/vault/docs

---

## Historique de Vault

### 2015 : Lancement initial
- Présentation de Vault par HashiCorp dans sa version 0.1.
- Fonctionnalités de base : gestion des secrets et chiffrement.

### 2016-2017 : Montée en puissance
- Introduction des backends de stockage dynamiques pour les bases de données et le cloud.
- Authentification via tokens, LDAP, AWS IAM, etc.

### 2018 : Intégration avec Kubernetes
- Support de l’injection de secrets dans les pods via l’agent Vault.
- Gestion des certificats TLS.

### 2019-2020 : Vers une solution d'entreprise
- Version 1.0 avec haute disponibilité (HA) et audit.
- Arrivée des politiques de contrôle d'accès (ACL).

### 2021 à aujourd'hui : Sécurité et automatisation
- Workflows zéro confiance (Zero Trust).
- Intégration avec des solutions CI/CD.

---

## Enjeux de la gestion des secrets avec Vault

### Sécurité des secrets
- Centralisation des secrets pour limiter leur dispersion.
- Chiffrement des données en stockage et en transit.
- Gestion dynamique pour limiter les risques d'exposition.

### Rotation et révocation
- Rotation automatique des secrets pour limiter les risques.
- Révocation immédiate des accès en cas de compromission.

### Gestion des accès
- Authentification multi-facteurs (MFA).
- Contrôle d’accès basé sur les rôles (RBAC).
- Audits détaillés pour retracer les opérations.

### Intégration et automatisation
- Sécurisation des pipelines CI/CD.
- Injection dynamique des secrets dans Kubernetes.
- Gestion des accès aux services cloud via des tokens temporaires.

---

## Cas d'utilisation
- CI/CD sécurisé avec GitLab CI ou Jenkins.
- Injection automatique des secrets dans les pods Kubernetes via Vault Agent Injector.
- Rotation automatique des mots de passe pour les bases de données SQL et NoSQL (difficile a faire pour le moment). 
- Zero Trust : authentification basée sur des tokens temporaires.()

---

## Démonstration pratique
- Intégration de Vault dans Kubernetes.
- Configuration d'un backend de secrets dynamique pour PostgreSQL.
- Mise en place d'une rotation automatique de mot de passe.

---

## Conclusion
HashiCorp Vault est devenu un standard pour la gestion des secrets dans les environnements cloud-native. Une gestion proactive et centralisée est essentielle pour sécuriser ces environnements modernes.

