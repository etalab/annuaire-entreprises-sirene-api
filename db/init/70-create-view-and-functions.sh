
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "DROP VIEW IF EXISTS etablissements_view"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "
CREATE VIEW etablissements_view AS 
    SELECT 
        T.activiteprincipaleetablissement as activite_principale, 
        N.activite_principale_entreprise, 
        T.activiteprincipaleregistremetiersetablissement as activite_principale_registre_metier, 
        N.categorie_entreprise, 
        T.codecedexetablissement as cedex, 
        T.codepostaletablissement as code_postal, 
        T.datecreationetablissement as date_creation, 
        N.date_creation_entreprise, 
        T.datedebut as date_debut_activite, 
        N.date_mise_a_jour, 
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
        T.indicerepetitionetablissement as indice_repetition,
        T.longitude, 
        N.nature_juridique_entreprise, 
        T.nic, 
        N.nic_siege, 
        N.nom, 
        N.nom_raison_sociale, 
        T.numerovoieetablissement as numero_voie, 
        N.prenom, 
        N.sigle, 
        N.siren, 
        T.siret, 
        T.trancheeffectifsetablissement as tranche_effectif_salarie, 
        N.tranche_effectif_salarie_entreprise, 
        T.typevoieetablissement as type_voie, 
        T.codecommuneetablissement as commune, 
        T.etatadministratifetablissement as etat_administratif_etablissement
    FROM siret T 
    LEFT JOIN siren_full N 
    ON N.siren = T.siren;"
    

psql -U $POSTGRES_USER -d $POSTGRES_DB -c "
CREATE VIEW etablissements_siren AS 
    SELECT 
        T.activiteprincipaleetablissement as activite_principale, 
        N.activite_principale_entreprise, 
        T.activiteprincipaleregistremetiersetablissement as activite_principale_registre_metier, 
        N.categorie_entreprise, 
        T.codecedexetablissement as cedex, 
        T.codepostaletablissement as code_postal, 
        T.datecreationetablissement as date_creation, 
        N.date_creation_entreprise, 
        T.datedebut as date_debut_activite, 
        N.date_mise_a_jour, 
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
        T.indicerepetitionetablissement as indice_repetition,
        T.longitude, 
        N.nature_juridique_entreprise, 
        T.nic, 
        N.nic_siege, 
        N.nom, 
        N.nom_raison_sociale, 
        T.numerovoieetablissement as numero_voie, 
        N.prenom, 
        N.sigle, 
        N.siren, 
        T.siret, 
        T.trancheeffectifsetablissement as tranche_effectif_salarie, 
        N.tranche_effectif_salarie_entreprise, 
        T.typevoieetablissement as type_voie, 
        T.codecommuneetablissement as commune, 
        T.etatadministratifetablissement as etat_administratif_etablissement,
        N.nombre_etablissements,
        N.numero_tva_intra 
    FROM siret T 
    LEFT JOIN siren_full N 
    ON N.siren = T.siren;"






psql -U $POSTGRES_USER -d $POSTGRES_DB  -c "CREATE OR REPLACE FUNCTION get_etablissements (siren_search text, page_ask text) 
returns table (
    unite_legale jsonb
) 
language plpgsql
as \$\$ 
DECLARE 
    nbent INTEGER := (SELECT nombre_etablissements FROM siren_full WHERE siren = siren_search);
    maxent INTEGER := 200;
BEGIN
    IF (nbent < maxent) THEN
        return query 
            SELECT 
                    jsonb_agg(
                        json_build_object(
                            'activite_principale', t.activite_principale,
                            'activite_principale_entreprise', t.activite_principale_entreprise,
                            'activite_principale_registre_metier', t.activite_principale_registre_metier,
                            'categorie_entreprise', t.categorie_entreprise,
                            'cedex', t.cedex,
                            'code_postal', t.code_postal,
                            'date_creation', t.date_creation,
                            'date_creation_entreprise', t.date_creation_entreprise,
                            'date_debut_activite', t.date_debut_activite,
                            'date_mise_a_jour', t.date_mise_a_jour,
                            'enseigne', t.enseigne,
                            'geo_adresse', t.geo_adresse,
                            'geo_id', t.geo_id,
                            'geo_l4', t.geo_l4,
                            'geo_l5', t.geo_l5,
                            'geo_ligne', t.geo_ligne,
                            'geo_score', t.geo_score,
                            'geo_type', t.geo_type,
                            'is_siege', t.is_siege,
                            'latitude', t.latitude,
                            'libelle_commune', t.libelle_commune,
                            'libelle_voie', t.libelle_voie,
                            'longitude', t.longitude,
                            'nature_juridique_entreprise', t.nature_juridique_entreprise,
                            'nic', t.nic,
                            'nic_siege', t.nic_siege,
                            'nom', t.nom,
                            'nom_raison_sociale', t.nom_raison_sociale,
                            'numero_voie', t.numero_voie,
                            'prenom', t.prenom,
                            'sigle', t.sigle,
                            'siren', t.siren,
                            'siret', t.siret,
                            'tranche_effectif_salarie', t.tranche_effectif_salarie,
                            'tranche_effectif_salarie_entreprise', t.tranche_effectif_salarie_entreprise,
                            'type_voie', t.type_voie,
                            'commune', t.commune,
                            'nombre_etablissements', t.nombre_etablissements,
                            'etat_administratif_etablissement', t.etat_administratif_etablissement,
                            'etablissements', t.etablissements_array,
                            'etablissement_siege', t.etablissement_siege,
                            'numero_tva_intra', t.numero_tva_intra
                        )
                    ) as unite_legale
            FROM 
                (
                    SELECT
                        ul.*,
                        (SELECT json_agg(t1) FROM (SELECT * from etablissements_siren WHERE siren = siren_search ORDER BY is_siege DESC,etat_administratif_etablissement) t1) as etablissements_array,
                        (SELECT json_agg(t2) FROM (SELECT * from etablissements_siren WHERE siren = siren_search AND is_siege = 't') t2) as etablissement_siege
                    FROM 
                        siren_full ul
                    WHERE 
                        ul.siren = siren_search
                ) t;    
    ELSE
        return query 
            SELECT 
                    jsonb_agg(
                        json_build_object(
                            'activite_principale', t.activite_principale,
                            'activite_principale_entreprise', t.activite_principale_entreprise,
                            'activite_principale_registre_metier', t.activite_principale_registre_metier,
                            'categorie_entreprise', t.categorie_entreprise,
                            'cedex', t.cedex,
                            'code_postal', t.code_postal,
                            'date_creation', t.date_creation,
                            'date_creation_entreprise', t.date_creation_entreprise,
                            'date_debut_activite', t.date_debut_activite,
                            'date_mise_a_jour', t.date_mise_a_jour,
                            'enseigne', t.enseigne,
                            'geo_adresse', t.geo_adresse,
                            'geo_id', t.geo_id,
                            'geo_l4', t.geo_l4,
                            'geo_l5', t.geo_l5,
                            'geo_ligne', t.geo_ligne,
                            'geo_score', t.geo_score,
                            'geo_type', t.geo_type,
                            'is_siege', t.is_siege,
                            'latitude', t.latitude,
                            'libelle_commune', t.libelle_commune,
                            'libelle_voie', t.libelle_voie,
                            'longitude', t.longitude,
                            'nature_juridique_entreprise', t.nature_juridique_entreprise,
                            'nic', t.nic,
                            'nic_siege', t.nic_siege,
                            'nom', t.nom,
                            'nom_raison_sociale', t.nom_raison_sociale,
                            'numero_voie', t.numero_voie,
                            'prenom', t.prenom,
                            'sigle', t.sigle,
                            'siren', t.siren,
                            'siret', t.siret,
                            'tranche_effectif_salarie', t.tranche_effectif_salarie,
                            'tranche_effectif_salarie_entreprise', t.tranche_effectif_salarie_entreprise,
                            'type_voie', t.type_voie,
                            'commune', t.commune,
                            'nombre_etablissements', t.nombre_etablissements,
                            'etat_administratif_etablissement', t.etat_administratif_etablissement,
                            'etablissements', t.etablissements_array,
                            'etablissement_siege', t.etablissement_siege,
                            'numero_tva_intra', t.numero_tva_intra
                        )
                    ) as unite_legale
            FROM 
                (
                    SELECT
                        ul.*,
                        (SELECT json_agg(t1) FROM (SELECT * from etablissements_siren WHERE siren = siren_search LIMIT maxent OFFSET (CAST(page_ask AS INTEGER)-1)*maxent) t1) as etablissements_array,
                        (SELECT json_agg(t2) FROM (SELECT * from etablissements_siren WHERE siren = siren_search AND is_siege = 't') t2) as etablissement_siege
                    FROM 
                        siren_full ul
                    WHERE 
                        ul.siren = siren_search
                ) t;   
    END IF;
end;\$\$;"



psql -U $POSTGRES_USER -d $POSTGRES_DB  -c "CREATE OR REPLACE FUNCTION get_etablissement (siret_search text) 
returns table (
    etablissement jsonb
) 
language plpgsql
as \$\$ 
BEGIN
    return query 
        SELECT 
                jsonb_agg(
                    json_build_object(

                    'activite_principale', t.activite_principale, 
                    'activite_principale_entreprise', t.activite_principale_entreprise, 
                    'activite_principale_registre_metier', t.activite_principale_registre_metier, 
                    'categorie_entreprise', t.categorie_entreprise, 
                    'cedex', t.cedex, 
                    'code_postal', t.code_postal, 
                    'date_creation', t.date_creation, 
                    'date_creation_entreprise', t.date_creation_entreprise, 
                    'date_debut_activite', t.date_debut_activite, 
                    'date_mise_a_jour', t.date_mise_a_jour, 
                    'enseigne', t.enseigne, 
                    'geo_adresse', t.geo_adresse, 
                    'geo_id', t.geo_id, 
                    'geo_l4', t.geo_l4, 
                    'geo_l5', t.geo_l5, 
                    'geo_ligne', t.geo_ligne, 
                    'geo_score', t.geo_score, 
                    'geo_type', t.geo_type, 
                    'is_siege', t.is_siege, 
                    'latitude', t.latitude, 
                    'libelle_commune', t.libelle_commune, 
                    'libelle_voie', t.libelle_voie, 
                    'indice_repetition', t.indice_repetition,
                    'longitude', t.longitude, 
                    'nature_juridique_entreprise', t.nature_juridique_entreprise, 
                    'nic', t.nic, 
                    'nic_siege', t.nic_siege, 
                    'nom', t.nom, 
                    'nom_raison_sociale', t.nom_raison_sociale, 
                    'numero_voie', t.numero_voie, 
                    'prenom', t.prenom, 
                    'sigle', t.sigle, 
                    'siren', t.siren, 
                    'siret', t.siret, 
                    'tranche_effectif_salarie', t.tranche_effectif_salarie, 
                    'tranche_effectif_salarie_entreprise', t.tranche_effectif_salarie_entreprise, 
                    'type_voie', t.type_voie, 
                    'commune', t.commune, 
                    'etat_administratif_etablissement', t.etat_administratif_etablissement,
                    'unite_legale', t.unite_legale
                    )
                ) as etablissement
        FROM 
            (
                SELECT
                    ev.*,
                    (SELECT * FROM get_etablissements(ev.siren, '1') t1) as unite_legale
                FROM 
                    etablissements_view ev
                WHERE 
                    ev.siret = siret_search
            ) t;        
end;\$\$;"
