
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "
    CREATE TABLE siren_full
    AS (
        SELECT 
            T.activiteprincipaleetablissement as activite_principale, 
            N.activiteprincipaleunitelegale as activite_principale_entreprise, 
            T.activiteprincipaleregistremetiersetablissement as activite_principale_registre_metier, 
            N. categorieentreprise as categorie_entreprise, 
            T.codecedexetablissement as cedex, 
            T.codepostaletablissement as code_postal, 
            T.datecreationetablissement as date_creation, N.datecreationunitelegale as date_creation_entreprise, 
            T.datedebut as date_debut_activite, 
            N.datederniertraitementunitelegale as date_mise_a_jour, 
            T.enseigne1etablissement as enseigne, 
            T.geo_adresse, 
            T.geo_id, 
            T.geo_l4, 
            T.geo_l5, 
            T.geo_ligne, 
            T.geo_score, 
            T.geo_type, 
            T.etablissementsiege as is_siege, 
            T.latitude, 
            T.libellecommuneetablissement as libelle_commune, 
            T.libellevoieetablissement as libelle_voie, 
            T.longitude, 
            N.categoriejuridiqueunitelegale as nature_juridique_entreprise, 
            T.nic, 
            N.nicsiegeunitelegale as nic_siege, 
            N.nomunitelegale as nom, 
            N.denominationunitelegale as nom_raison_sociale, 
            T.numerovoieetablissement as numero_voie, 
            N.prenom1unitelegale as prenom, 
            N.sigleunitelegale as sigle, 
            N.siren, 
            T.siret, 
            T.trancheeffectifsetablissement as tranche_effectif_salarie, 
            N.trancheeffectifsunitelegale as tranche_effectif_salarie_entreprise, 
            T.typevoieetablissement as type_voie, 
            T.codecommuneetablissement as commune,
            T.etatadministratifetablissement as etat_administratif_etablissement,
            N.enseignes,
            N.tsv,
            N.nombre_etablissements,
            N.etablissements,
            N.nom_complet,
            N.nom_url,
            numero_tva_intra,
            N.tsv_nomentreprise,
            N.tsv_enseigne,
            N.tsv_nomprenom,
            N.tsv_adresse
        FROM siret T 
        LEFT JOIN siren N 
        ON N.siren = T.siren
        WHERE T.etablissementsiege = 't'
    );"



psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_full_siren ON siren_full (siren);"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_full_siret ON siren_full (siret);"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_full_commune ON siren_full (commune);"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_full_tsv ON siren_full USING gin(tsv);"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_full_tsv_nomentreprise ON siren_full USING gin(tsv_nomentreprise);"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_full_tsv_nomprenom ON siren_full USING gin(tsv_nomprenom);"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_full_tsv_enseigne ON siren_full USING gin(tsv_enseigne);"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_full_tsv_adresse ON siren_full USING gin(tsv_adresse);"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_full_nom_raison_sociale ON siren_full USING gin (nom_raison_sociale gin_trgm_ops);"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_full_activite_principale ON siren_full (activite_principale);"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE INDEX siren_full_nature_juridique_entreprise ON siren_full (nature_juridique_entreprise);"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "DROP TABLE siren;"