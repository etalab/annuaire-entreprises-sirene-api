psql -U $POSTGRES_USER -d $POSTGRES_DB -c "ALTER TABLE siren ADD COLUMN enseignes TEXT;"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "UPDATE siren S SET enseignes = (SELECT STRING_AGG(enseignes,', ') AS enseignes FROM (select DISTINCT ST.enseigne1etablissement as enseignes from siret ST where ST.siren = S.siren AND ST.enseigne1etablissement IS NOT NULL) tbl);"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "DROP VIEW IF EXISTS intermediary_view"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "ALTER TABLE siren ADD COLUMN nombre_etablissements INTEGER;"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "UPDATE siren S SET nombre_etablissements = (SELECT COUNT(*) AS nombre_etablissements from siret where siren = S.siren);"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "ALTER TABLE siren ADD COLUMN numero_tva_intra TEXT;"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "UPDATE siren S SET numero_tva_intra = (SELECT CASE WHEN tvanumber < 10 THEN concat('FR0',tvanumber,siren) ELSE CONCAT('FR',tvanumber,siren) END FROM (SELECT (12+(3*bigintsiren)%97)%97 as tvanumber, siren FROM (select CAST (siren as BIGINT) as bigintsiren,siren from siren WHERE siren = S.siren) tbl) tbl2);"

