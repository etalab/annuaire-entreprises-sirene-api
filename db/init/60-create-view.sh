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
        N.etablissements,
        N.nombre_etablissements
    FROM siret T 
    LEFT JOIN siren N 
    ON N.siren = T.siren
    WHERE T.etablissementsiege = 't'
    AND T.etatadministratifetablissement = 'A';"


psql -U $POSTGRES_USER -d $POSTGRES_DB -c "
create or replace function get_unite_legale (
  search text,
  page_ask text,
  per_page_ask text
) 
	returns table (
		unite_legale jsonb,
        total_results bigint,
        total_pages integer,
        page integer,
        per_page integer
	) 
	language plpgsql
as $$
begin
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
                        'etablissements', t.etablissements,
                        'nombre_etablissements', t.nombre_etablissements,
                        'score', t.score
                    )
                ) as unite_legale,
                min(t.rowcount) as total_results,
                CAST (ROUND((min(t.rowcount)/(CAST (per_page_ask AS INTEGER)))) AS INTEGER) as total_pages,
                CAST (page_ask AS INTEGER) as per_page,
                CAST (per_page_ask AS INTEGER) as page
        FROM 
            (
                SELECT
                    COUNT(*) OVER () as rowcount,
                    ts_rank(tsv,to_tsquery(REPLACE (search, '%20', ' & ')),1) as score,
                    activite_principale, 
                    activite_principale_entreprise, 
                    activite_principale_registre_metier, 
                    categorie_entreprise, 
                    cedex, 
                    code_postal, 
                    date_creation, 
                    date_creation_entreprise, 
                    date_debut_activite, 
                    date_mise_a_jour, 
                    enseigne, 
                    geo_adresse, 
                    geo_id, 
                    geo_l4, 
                    geo_l5, 
                    geo_ligne, 
                    geo_score, 
                    geo_type, 
                    is_siege, 
                    latitude, 
                    libelle_commune, 
                    libelle_voie, 
                    longitude, 
                    nature_juridique_entreprise, 
                    nic, 
                    nic_siege, 
                    nom, 
                    nom_raison_sociale, 
                    numero_voie, 
                    prenom, 
                    sigle, 
                    siren, 
                    siret, 
                    tranche_effectif_salarie, 
                    tranche_effectif_salarie_entreprise, 
                    type_voie, 
                    commune, 
                    tsv,
                    etablissements,
                    nombre_etablissements
                FROM
                    unitelegale_view 
                WHERE 
                    tsv @@ to_tsquery(REPLACE (search, '%20', ' & '))
                ORDER BY score DESC, nombre_etablissements DESC
                LIMIT CAST (per_page_ask AS INTEGER)
                OFFSET ((CAST (page_ask AS INTEGER) - 1)*(CAST (per_page_ask AS INTEGER)))
            ) t;        
end;$$;
"


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

