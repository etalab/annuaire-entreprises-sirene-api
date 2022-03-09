psql -U $POSTGRES_USER -d $POSTGRES_DB -c "\copy (select nom_url from siren_full WHERE etat_administratif_etablissement = 'A') to '/tmp/sitemap-name.csv' with csv"

