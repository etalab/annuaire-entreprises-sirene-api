psql -U $POSTGRES_USER -d $POSTGRES_DB -c "DROP VIEW IF EXISTS etablissements_view"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE VIEW etablissements_view AS SELECT T.activiteprincipaleetablissement as activite_principale, N.activiteprincipaleunitelegale as activite_principale_entreprise, T.activiteprincipaleregistremetiersetablissement as activite_principale_registre_metier, N. categorieentreprise as categorie_entreprise, T.codecedexetablissement as cedex, T.codepostaletablissement as code_postal, T.datecreationetablissement as date_creation, N.datecreationunitelegale as date_creation_entreprise, T.datedebut as date_debut_activite, N.datederniertraitementunitelegale as date_mise_a_jour, T.enseigne1etablissement as enseigne, T.geo_adresse, T.geo_id, T.geo_l4, T.geo_l5, T.geo_ligne, T.geo_score, T.geo_type, T.etablissementsiege as is_siege, T.latitude, T.libellecommuneetablissement as libelle_commune, T.libellevoieetablissement as libelle_voie, T.longitude, N.categoriejuridiqueunitelegale as nature_juridique_entreprise, T.nic, N.nicsiegeunitelegale as nic_siege, N.nomunitelegale as nom, N.denominationunitelegale as nom_raison_sociale, T.numerovoieetablissement as numero_voie, N.prenom1unitelegale as prenom, N.sigleunitelegale as sigle, N.siren, T.siret, T.trancheeffectifsetablissement as tranche_effectif_salarie, N.trancheeffectifsunitelegale as tranche_effectif_salarie_entreprise, T.typevoieetablissement as type_voie, T.codecommuneetablissement as commune, N.tsv FROM siret T LEFT JOIN siren N ON N.siren = T.siren;"

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "
CREATE VIEW unitelegale_view AS 
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
        N.tsv,
        (SELECT STRING_AGG (siret, ',') AS etablissements from (SELECT siret FROM siret where siren = N.siren LIMIT 10) tbl),
        (SELECT COUNT(*) AS nombre_etablissements from siret where siren = N.siren)
    FROM siret T 
    LEFT JOIN siren N 
    ON N.siren = T.siren
    WHERE T.etablissementsiege = 't'
    AND T.etatadministratifetablissement = 'A';"



psql -U $POSTGRES_USER -d $POSTGRES_DB -c "
CREATE VIEW etablissements_siren AS 
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
        N.tsv,
        T.etatadministratifetablissement as etat_administratif_etablissement
    FROM siret T 
    LEFT JOIN siren N 
    ON N.siren = T.siren;"