psql -U $POSTGRES_USER -d $POSTGRES_DB -c "COPY siren(siren,statutDiffusionUniteLegale,unitePurgeeUniteLegale,dateCreationUniteLegale,sigleUniteLegale,sexeUniteLegale,prenom1UniteLegale,prenom2UniteLegale,prenom3UniteLegale,prenom4UniteLegale,prenomUsuelUniteLegale,pseudonymeUniteLegale, identifiantAssociationUniteLegale,trancheEffectifsUniteLegale,anneeEffectifsUniteLegale,dateDernierTraitementUniteLegale,nombrePeriodesUniteLegale,categorieEntreprise,anneeCategorieEntreprise,dateDebut,etatAdministratifUniteLegale,nomUniteLegale,nomUsageUniteLegale,denominationUniteLegale,denominationUsuelle1UniteLegale,denominationUsuelle2UniteLegale,denominationUsuelle3UniteLegale,categorieJuridiqueUniteLegale,activitePrincipaleUniteLegale,nomenclatureActivitePrincipaleUniteLegale,nicSiegeUniteLegale,economieSocialeSolidaireUniteLegale,caractereEmployeurUniteLegale) FROM '/var/lib/postgresql/files/StockUniteLegale_utf8.csv' delimiter ',' CSV HEADER ENCODING 'UTF8';"


psql -U $POSTGRES_USER -d $POSTGRES_DB -c "DROP INDEX IF EXISTS siren_siren;"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_siren ON siren (siren);"


psql -U $POSTGRES_USER -d $POSTGRES_DB -c "DROP INDEX IF EXISTS siren_denominationunitelegale;"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_denominationunitelegale ON siren USING gin (denominationunitelegale gin_trgm_ops);"


psql -U $POSTGRES_USER -d $POSTGRES_DB -c "DROP INDEX IF EXISTS siren_activitePrincipaleUniteLegale;"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_activitePrincipaleUniteLegale ON siren (activitePrincipaleUniteLegale);"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "DROP INDEX IF EXISTS siren_categorieJuridiqueUniteLegale;"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_categorieJuridiqueUniteLegale ON siren (categorieJuridiqueUniteLegale);"


