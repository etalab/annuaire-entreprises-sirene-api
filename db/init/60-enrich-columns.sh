psql -U $POSTGRES_USER -d $POSTGRES_DB -c "ALTER TABLE siren ADD COLUMN enseignes TEXT;"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "ALTER TABLE siren ADD COLUMN tsv tsvector;"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "ALTER TABLE siren ADD COLUMN tsv_nomentreprise tsvector;"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "ALTER TABLE siren ADD COLUMN tsv_nomprenom tsvector;"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "ALTER TABLE siren ADD COLUMN tsv_enseigne tsvector;"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "ALTER TABLE siren ADD COLUMN tsv_adresse tsvector;"


psql -U $POSTGRES_USER -d $POSTGRES_DB -c "UPDATE siren S SET enseignes = (SELECT STRING_AGG(enseignes,', ') AS enseignes FROM (select DISTINCT ST.enseigne1etablissement as enseignes from siret ST where ST.siren = S.siren AND ST.enseigne1etablissement IS NOT NULL) tbl);"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "UPDATE siren S
SET tsv_nomentreprise = 
setweight(to_tsvector(coalesce(sigleUniteLegale,'')), 'A') || 
setweight(to_tsvector(coalesce(denominationUniteLegale,'')), 'B');"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "UPDATE siren S
SET tsv_nomprenom = 
setweight(to_tsvector(coalesce(nomUniteLegale,'')), 'A') || 
setweight(to_tsvector(coalesce(prenom1UniteLegale,'')), 'A');"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "UPDATE siren
SET tsv_enseigne = 
setweight(to_tsvector(coalesce(enseignes,'')), 'A');"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "UPDATE siren S
SET tsv_adresse = 
setweight(to_tsvector(coalesce(intermediary_view.numero_voie,'')), 'A') ||
setweight(to_tsvector(coalesce(intermediary_view.type_voie,'')), 'A') ||
setweight(to_tsvector(coalesce(intermediary_view.libelle_voie,'')), 'A') ||
setweight(to_tsvector(coalesce(intermediary_view.commune,'')), 'A') ||
setweight(to_tsvector(coalesce(intermediary_view.code_postal,'')), 'A') ||
setweight(to_tsvector(coalesce(intermediary_view.libelle_commune,'')), 'A')
FROM intermediary_view  WHERE S.siren = intermediary_view.siren;"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "UPDATE siren S

SET tsv = 
setweight(to_tsvector(coalesce(S.sigleUniteLegale,'')), 'A') || 
setweight(to_tsvector(coalesce(S.denominationUniteLegale,'')), 'B') || 
setweight(to_tsvector(coalesce(S.enseignes,'')), 'C') || 
setweight(to_tsvector(coalesce(S.nomUniteLegale,'')), 'D') || 
setweight(to_tsvector(coalesce(S.prenom1UniteLegale,'')), 'D') ||
setweight(to_tsvector(coalesce(intermediary_view.numero_voie,'')), 'D') ||
setweight(to_tsvector(coalesce(intermediary_view.type_voie,'')), 'D') ||
setweight(to_tsvector(coalesce(intermediary_view.libelle_voie,'')), 'D') ||
setweight(to_tsvector(coalesce(intermediary_view.commune,'')), 'D') ||
setweight(to_tsvector(coalesce(intermediary_view.code_postal,'')), 'D') ||
setweight(to_tsvector(coalesce(intermediary_view.libelle_commune,'')), 'D') 
FROM intermediary_view WHERE S.siren = intermediary_view.siren;"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_tsv ON siren USING gin(tsv);"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_tsv_nomentreprise ON siren USING gin(tsv_nomentreprise);"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_tsv_nomprenom ON siren USING gin(tsv_nomprenom);"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_tsv_enseigne ON siren USING gin(tsv_enseigne);"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_tsv_adresse ON siren USING gin(tsv_adresse);"


psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_denominationunitelegale ON siren USING gin (denominationunitelegale gin_trgm_ops);"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_activitePrincipaleUniteLegale ON siren (activitePrincipaleUniteLegale);"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_categorieJuridiqueUniteLegale ON siren (categorieJuridiqueUniteLegale);"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siret_codeCommuneEtablissement ON siret (codeCommuneEtablissement);"


psql -U $POSTGRES_USER -d $POSTGRES_DB -c "DROP VIEW IF EXISTS intermediary_view"

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

