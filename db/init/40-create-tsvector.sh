psql -U $POSTGRES_USER -d $POSTGRES_DB -c "ALTER TABLE siren ADD COLUMN tsv tsvector;"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "UPDATE siren SET tsv = setweight(to_tsvector(coalesce(denominationunitelegale,'')), 'A') || setweight(to_tsvector(coalesce(nomunitelegale,'')), 'B') || setweight(to_tsvector(coalesce(prenom1unitelegale,'')), 'C');"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_tsv ON siren USING gin(tsv);"


