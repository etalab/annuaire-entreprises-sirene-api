#!/bin/sh

ENV="db-blue"
echo $ENV

if [ $(docker ps -f name=$ENV -q | wc -l) = 0 ]
then
    ENV="blue"
    OLD="green"
else
    ENV="green"
    OLD="blue"
fi

echo $ENV

echo "Starting Postgres "$ENV" container"
docker-compose -f docker-compose-postgres-$ENV.yml --project-name=$ENV up --build -d

while [ $(docker ps --filter "health=healthy" | grep $ENV | wc -l) = 0 ]
do
    sleep 30s
    echo "Waiting..."
done

echo "Starting Postgrest "$ENV" container"
docker-compose -f docker-compose-postgrest-$ENV.yml --project-name=$ENV up --build -d

while [ $(docker ps --filter "health=healthy" | grep $ENV | wc -l) = 0 ]
do
    sleep 30s
    echo "Waiting..."
done

echo "Container up and healthy"

echo "Stopping "$OLD" container"
docker-compose -f docker-compose-postgres-$OLD.yml --project-name=$OLD down
docker-compose -f docker-compose-postgrest-$OLD.yml --project-name=$OLD down
