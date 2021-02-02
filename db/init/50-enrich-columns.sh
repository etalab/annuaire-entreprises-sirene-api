psql -U $POSTGRES_USER -d $POSTGRES_DB -c "ALTER TABLE siren ADD COLUMN enseignes TEXT;"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "UPDATE siren S SET enseignes = (SELECT STRING_AGG(enseignes,', ') AS enseignes FROM (select DISTINCT ST.enseigne1etablissement as enseignes from siret ST where ST.siren = S.siren AND ST.enseigne1etablissement IS NOT NULL) tbl);"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "ALTER TABLE siren ADD COLUMN tsv tsvector;"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "UPDATE siren S SET tsv = setweight(to_tsvector(coalesce(S.sigleunitelegale,'')), 'A') || setweight(to_tsvector(coalesce(S.denominationunitelegale,'')), 'B') || setweight(to_tsvector(coalesce(S.enseignes,'')), 'C') || setweight(to_tsvector(coalesce(S.nomunitelegale,'')), 'D') || setweight(to_tsvector(coalesce(S.prenom1unitelegale,'')), 'D');"


psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_tsv ON siren USING gin(tsv);"


psql -U $POSTGRES_USER -d $POSTGRES_DB -c "ALTER TABLE siren ADD COLUMN etablissements TEXT;"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "UPDATE siren S SET etablissements = (SELECT STRING_AGG (siret, ',') AS etablissements from (SELECT siret FROM siret where siren = S.siren LIMIT 10) tbl);"


psql -U $POSTGRES_USER -d $POSTGRES_DB -c "ALTER TABLE siren ADD COLUMN nombre_etablissements INTEGER;"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "UPDATE siren S SET nombre_etablissements = (SELECT COUNT(*) AS nombre_etablissements from siret where siren = S.siren);"


psql -U $POSTGRES_USER -d $POSTGRES_DB -c "ALTER TABLE siren ADD COLUMN nom_complet TEXT;"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "UPDATE siren S SET nom_complet = (SELECT
    CASE WHEN S.categoriejuridiqueunitelegale = '1000' THEN
        CASE WHEN S.sigleunitelegale IS NOT NULL THEN
            COALESCE(LOWER(S.prenom1unitelegale),'') || COALESCE(' ' || LOWER(S.nomunitelegale),'') || COALESCE(' (' || LOWER(S.sigleunitelegale) || ')','')
        ELSE
            COALESCE(LOWER(S.prenom1unitelegale),'') || COALESCE(' ' || LOWER(S.nomunitelegale),'')
        END
    ELSE
        CASE WHEN S.sigleunitelegale IS NOT NULL THEN
            COALESCE(LOWER(S.denominationunitelegale),'') || COALESCE(LOWER(' (' || S.sigleunitelegale || ')'),'')
        ELSE
            COALESCE(LOWER(S.denominationunitelegale),'')
        END
    END
);"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "ALTER TABLE siren ADD COLUMN nom_url TEXT;"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "UPDATE siren S SET nom_url = regexp_replace(nom_complet || '-' || siren, '[^a-zA-Z0-9]+', '-','g');"


psql -U $POSTGRES_USER -d $POSTGRES_DB -c "ALTER TABLE siren ADD COLUMN numero_tva_intra TEXT;"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "UPDATE siren S SET numero_tva_intra = (SELECT CASE WHEN tvanumber < 10 THEN concat('FR0',tvanumber,siren) ELSE CONCAT('FR',tvanumber,siren) END FROM (SELECT (12+(3*bigintsiren)%97)%97 as tvanumber, siren FROM (select CAST (siren as BIGINT) as bigintsiren,siren from siren WHERE siren = S.siren) tbl) tbl2);"