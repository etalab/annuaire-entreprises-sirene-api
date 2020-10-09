# Gestion de backend pour la base SIRENE Open Data

Ce repo a pour objectif de proposer une architecture simplifié pour la mise en API de la base open data SIRENE de l'INSEE.

## Architecture

L'architecture proposée est basée sur Docker (docker-compose). Deux services y sont proposés : 
- db : base de données Postgresql contenant l'ensemble des données de la base SIRENE
- postgrest : couche au-dessus de la base postgres qui propose un requêtage API sur la base simplifié. (voir documentation)

La base SIRENE open data se mettant à jour une fois par mois, il est proposé d'articuler ces services avec le reverse proxy Traefik pour limiter le temps d'indisponibilité du backend lors des migrations d'une ancienne base de données vers une nouvelle base de données.

Le workflow est donc le suivant : 
- Exécution des services ```db``` et ```postgrest``` sur un réseau docker dédié
- Exposition du point d'API via un routing de ```traefik``` vers le service ```postgrest```
- Au 1er du mois, exécution de nouveaux services ```db``` et ```postgrest```. Tant que les services ne sont pas opérationnels (cad tant que les données ne sont pas complètement chargées dans le service ```db```)
- Une fois les nouveaux services ```db``` et ```postgrest``` prêts, on déconnecte leurs précédentes versions 


## Installation

1. Clone du repo

2. Mise en place de Traefik et création d'un réseau docker dédié

```
docker-compose -f docker-compose-traefik.yml up --build -d
```

3. Première mise en production du backend 

```
docker-compose -f docker-compose-blue.yml build --no-cache
docker-compose -f docker-compose-blue.yml up --build -d
```

4. Lorsqu'une nouvelle version des données est disponible : 

```
./deploy.sh
```