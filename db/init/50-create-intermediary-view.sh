
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "
CREATE VIEW intermediary_view AS 
    SELECT 
        T.codepostaletablissement as code_postal, 
        T.libellecommuneetablissement as libelle_commune, 
        T.libellevoieetablissement as libelle_voie, 
        N.nomunitelegale as nom, 
        N.denominationunitelegale as nom_raison_sociale, 
        T.numerovoieetablissement as numero_voie, 
        N.prenom1unitelegale as prenom, 
        N.sigleunitelegale as sigle, 
        N.siren, 
        T.siret, 
        T.typevoieetablissement as type_voie, 
        T.codecommuneetablissement as commune
    FROM siret T 
    LEFT JOIN siren N 
    ON N.siren = T.siren
    WHERE T.etablissementsiege = 't';"

