psql -h localhost -p 5434 -U sirene -d sirene -c "DROP TABLE IF EXISTS siren"
psql -h localhost -p 5434 -U sirene -d sirene -c "DROP TABLE IF EXISTS siret"
psql -h localhost -p 5434 -U sirene -d sirene -f "./create_siren.sql"
psql -h localhost -p 5434 -U sirene -d sirene -f "./create_siret.sql"

