psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE SCHEMA $POSTGRES_DB;"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "SET search_path TO $POSTGRES_DB, public;"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE EXTENSION pg_trgm;"


psql -U $POSTGRES_USER -d $POSTGRES_DB -c "ALTER SYSTEM SET max_wal_size = '30GB';"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "ALTER SYSTEM SET work_mem = '16GB';"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "SELECT * FROM pg_reload_conf();"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE TABLE siren
(
	id_siren SERIAL PRIMARY KEY NOT NULL,
    siren CHARACTER VARYING,
    statutDiffusionUniteLegale CHARACTER VARYING,
    unitePurgeeUniteLegale CHARACTER VARYING,
    dateCreationUniteLegale  date default NULL,
    sigleUniteLegale CHARACTER VARYING,
    sexeUniteLegale CHARACTER VARYING,
    prenom1UniteLegale CHARACTER VARYING,
    prenom2UniteLegale CHARACTER VARYING,
    prenom3UniteLegale CHARACTER VARYING,
    prenom4UniteLegale CHARACTER VARYING,
    prenomUsuelUniteLegale CHARACTER VARYING,
    pseudonymeUniteLegale CHARACTER VARYING,
    identifiantAssociationUniteLegale CHARACTER VARYING,
    trancheEffectifsUniteLegale CHARACTER VARYING,
    anneeEffectifsUniteLegale CHARACTER VARYING,
    dateDernierTraitementUniteLegale date default NULL,
    nombrePeriodesUniteLegale CHARACTER VARYING,
    categorieEntreprise CHARACTER VARYING,
    anneeCategorieEntreprise CHARACTER VARYING,
    dateDebut date default NULL,
    etatAdministratifUniteLegale CHARACTER VARYING,
    nomUniteLegale CHARACTER VARYING,
    nomUsageUniteLegale CHARACTER VARYING,
    denominationUniteLegale CHARACTER VARYING,
    denominationUsuelle1UniteLegale CHARACTER VARYING,
    denominationUsuelle2UniteLegale CHARACTER VARYING,
    denominationUsuelle3UniteLegale CHARACTER VARYING,
    categorieJuridiqueUniteLegale CHARACTER VARYING,
    activitePrincipaleUniteLegale CHARACTER VARYING,
    nomenclatureActivitePrincipaleUniteLegale CHARACTER VARYING,
    nicSiegeUniteLegale CHARACTER VARYING,
    economieSocialeSolidaireUniteLegale CHARACTER VARYING,
    caractereEmployeurUniteLegale CHARACTER VARYING,
    UNIQUE(siren)
)
TABLESPACE pg_default;"


psql -U sirene -d sirene -c "CREATE TABLE siret
(
	id_siret SERIAL PRIMARY KEY NOT NULL,
    siren CHARACTER VARYING,
    nic CHARACTER VARYING,
    siret CHARACTER VARYING,
    statutDiffusionEtablissement CHARACTER VARYING,
    dateCreationEtablissement date default NULL,
    trancheEffectifsEtablissement CHARACTER VARYING,
    anneeEffectifsEtablissement DECIMAL(9,2),
    activitePrincipaleRegistreMetiersEtablissement CHARACTER VARYING,
    dateDernierTraitementEtablissement TIMESTAMP default NULL,
    etablissementSiege BOOLEAN,
    nombrePeriodesEtablissement DECIMAL(9,2),
    complementAdresseEtablissement CHARACTER VARYING,
    numeroVoieEtablissement CHARACTER VARYING,
    indiceRepetitionEtablissement CHARACTER VARYING,
    typeVoieEtablissement CHARACTER VARYING,
    libelleVoieEtablissement CHARACTER VARYING,
    codePostalEtablissement CHARACTER VARYING,
    libelleCommuneEtablissement CHARACTER VARYING,
    libelleCommuneEtrangerEtablissement CHARACTER VARYING,
    distributionSpecialeEtablissement CHARACTER VARYING,
    codeCommuneEtablissement CHARACTER VARYING,
    codeCedexEtablissement CHARACTER VARYING,
    libelleCedexEtablissement CHARACTER VARYING,
    codePaysEtrangerEtablissement CHARACTER VARYING,
    libellePaysEtrangerEtablissement CHARACTER VARYING,
    complementAdresse2Etablissement CHARACTER VARYING,
    numeroVoie2Etablissement CHARACTER VARYING,
    indiceRepetition2Etablissement CHARACTER VARYING,
    typeVoie2Etablissement CHARACTER VARYING,
    libelleVoie2Etablissement CHARACTER VARYING,
    codePostal2Etablissement CHARACTER VARYING,
    libelleCommune2Etablissement CHARACTER VARYING,
    libelleCommuneEtranger2Etablissement CHARACTER VARYING,
    distributionSpeciale2Etablissement CHARACTER VARYING,
    codeCommune2Etablissement CHARACTER VARYING,
    codeCedex2Etablissement CHARACTER VARYING,
    libelleCedex2Etablissement CHARACTER VARYING,
    codePaysEtranger2Etablissement CHARACTER VARYING,
    libellePaysEtranger2Etablissement CHARACTER VARYING,
    dateDebut  date default NULL,
    etatAdministratifEtablissement CHARACTER VARYING,
    enseigne1Etablissement CHARACTER VARYING,
    enseigne2Etablissement CHARACTER VARYING,
    enseigne3Etablissement CHARACTER VARYING,
    denominationUsuelleEtablissement CHARACTER VARYING,
    activitePrincipaleEtablissement CHARACTER VARYING,
    nomenclatureActivitePrincipaleEtablissement CHARACTER VARYING,
    caractereEmployeurEtablissement CHARACTER VARYING,
    longitude  NUMERIC(14, 11),
    latitude  NUMERIC(14, 11),
    geo_score  DECIMAL(9,2),
    geo_type CHARACTER VARYING,
    geo_adresse CHARACTER VARYING,
    geo_id CHARACTER VARYING,
    geo_ligne CHARACTER VARYING, 
    geo_l4 CHARACTER VARYING,
    geo_l5 CHARACTER VARYING,
    typecom CHARACTER VARYING
)
TABLESPACE pg_default;"


