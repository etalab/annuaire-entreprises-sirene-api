# Gestion de backend pour la base SIRENE Open Data

Ce repo a pour objectif de proposer une architecture simplifiée pour la mise en API de la base open data SIRENE de l'INSEE.

## Architecture

L'architecture proposée est basée sur Docker (docker-compose). Deux services y sont proposés : 
- db : base de données Postgresql contenant l'ensemble des données de la base SIRENE
- postgrest : couche au-dessus de la base postgres qui propose un requêtage API sur la base simplifiée. ([voir documentation](http://postgrest.org/))

La base SIRENE open data se mettant à jour une fois par mois, il est proposé d'articuler ces services avec le reverse proxy Traefik pour limiter le temps d'indisponibilité du backend lors des migrations d'une ancienne base de données vers une nouvelle base de données.

Le workflow est donc le suivant : 
- Exécution des services ```db``` et ```postgrest``` sur un réseau docker dédié (les services mettent environ ~35 minutes pour se lancer complètement)
- Exposition du point d'API via un routing de ```traefik``` vers le service ```postgrest```
- Au 1er du mois, exécution de nouveaux services ```db``` et ```postgrest```. Tant que les services ne sont pas opérationnels (cad tant que les données ne sont pas complètement chargées dans le service ```db```), Traefik ne reroute pas vers le nouveau service ```postgrest```
- Une fois les nouveaux services ```db``` et ```postgrest``` prêts, on déconnecte leurs précédentes versions 

### Services

#### service db

Le service db est basé sur l'image docker postgresql 12. 

Lors de la phase de build, le dernier batch de données SIRENE est téléchargé dans l'image via les scripts contenus dans ```db/scripts``` :
- 0_get_last_siren_data.sh : téléchargement des derniers fichiers Siren
- 1_get_last_siret_data.sh : téléchargement des derniers fichiers Siret

Au démarrage du service, un certain nombre de script contenu dans ```db/init/``` sont exécutés : 
- 10-postgresql_setup.sql : Création de la base de données, de l'utilisateur principal et des deux tables ```siren``` et ```siret````
- 20-populate-siren.sql : Chargement des données SIREN dans la table ```siren```
- 30-populate-siret.sh : Chargement des données SIRET dans la table ```siret```
- 40-create-tsvector.sql : Création d'une colonne ```tsv``` dans la table ```siren``` pour faciliter la recherche des unités légales
- 50-create-view.sh : Création d'une vue ```etablissements_view``` permettant de requêter tous les établissemnts et comprenant des éléments au niveau unité légale

#### service postgrest

Le service postgrest permet de s'interfacer avec la base postgresql et offre une interface d'API sur celle-ci.

Les labels suivants permettent à Traefik de rerouter le traffic du port 3000 vers le container : 
```
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.postgrest.rule=Host(`localhost`)"
      - "traefik.http.routers.postgrest.entrypoints=postgrest"
      - "traefik.port=3000"
```

Un Healthcheck est ajouté afin d'indiquer à Traefik (via les docker Healthcheck) si le container est prêt ou non. Le healthcheck consiste à vérifier si la table etablissements_view est disponible ou non : 

```
HEALTHCHECK --interval=1s --timeout=3s \
  CMD PGPASSWORD=$POSTGRES_PASSWORD psql -h $POSTGRES_DB_HOST -p 5432 -U $POSTGRES_USER -d $POSTGRES_DB -c "select * from etablissements_view limit 1;"
```

#### script deploy.sh

Ce script permet de gérer les différents jeux de données d'un mois à l'autre. Un environnement courant est taggé avec la couleur ```blue``` (ou ```green```). Le script détecte la couleur actuelle et lance un docker-compose avec un tag de la couleur opposé. Une fois les services ```up``` et ```healthy```, le script coupe l'ancien service.


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

4. Accès à l'API

Vous pouvez accéder à l'API via http://IP:3000/ et requêter la base via la [documentation postgrest](http://postgrest.org/).
Exemple :
```
http://localhost:3000/etablissements_view?tsv=plfts.boucherie&limit=100 # Retourne les 100 premiers résultats de boucherie dans la base
```

5. Lorsqu'une nouvelle version des données est disponible : 

```
./deploy.sh
```
