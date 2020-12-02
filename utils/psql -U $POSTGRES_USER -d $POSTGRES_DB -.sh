psql -U $POSTGRES_USER -d $POSTGRES_DB  -c "CREATE OR REPLACE FUNCTION get_etablissements (siren_search text) 
returns table (
    unite_legale jsonb
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
                        'tsv', t.tsv,
                        'nombre_etablissements', t.nombre_etablissements,
                        'etat_administratif_etablissement', t.etat_administratif_etablissement,
                        'nom_complet', t.nom_complet,
                        'etablissements', t.etablissements_array,
                        'etablissement_siege', t.etablissement_siege
                    )
                ) as unite_legale
        FROM 
            (
                SELECT
                    ul.*,
                    (SELECT json_agg(t1) FROM (SELECT * from etablissements_siren WHERE siren = siren_search ORDER BY is_siege DESC,etat_administratif_etablissement) t1) as etablissements_array,
                    (SELECT json_agg(t2) FROM (SELECT * from etablissements_siren WHERE siren = siren_search AND is_siege = 't') t2) as etablissement_siege
                FROM 
                    unitelegale_view ul
                WHERE 
                    ul.siren = siren_search
            ) t;        
end;\$\$;"



