# Gestion de backend pour la base SIRENE Open Data

Ce repo a pour objectif de proposer une architecture simplifiée pour la mise en API de la base open data SIRENE de l'INSEE.


### Créer le réseau traefik

docker-compose docker-compose-traefik.yml up -d

### Créer le container elastic

docker-compose docker-compose-elastic.yml up -d

### Alimenter la base elastic

La base elastic est alimentée via un dag airflow

### Mettre à jour le proxy aio

docker-compose docker-compose-aio-$COLOR.yml up -d


