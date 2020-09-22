
for d in `seq -w 1 19` 2A 2B `seq 21 74` `seq 76 95` 98 ""; do
    psql -h localhost -p 5434 -U sirene -d sirene -c "\copy siret(siren, nic, siret, statutDiffusionEtablissement, dateCreationEtablissement, trancheEffectifsEtablissement, anneeEffectifsEtablissement, activitePrincipaleRegistreMetiersEtablissement, dateDernierTraitementEtablissement, etablissementSiege, nombrePeriodesEtablissement, complementAdresseEtablissement, numeroVoieEtablissement, indiceRepetitionEtablissement, typeVoieEtablissement, libelleVoieEtablissement, codePostalEtablissement, libelleCommuneEtablissement, libelleCommuneEtrangerEtablissement, distributionSpecialeEtablissement, codeCommuneEtablissement, codeCedexEtablissement, libelleCedexEtablissement, codePaysEtrangerEtablissement, libellePaysEtrangerEtablissement, complementAdresse2Etablissement, numeroVoie2Etablissement, indiceRepetition2Etablissement, typeVoie2Etablissement, libelleVoie2Etablissement, codePostal2Etablissement, libelleCommune2Etablissement, libelleCommuneEtranger2Etablissement, distributionSpeciale2Etablissement, codeCommune2Etablissement, codeCedex2Etablissement, libelleCedex2Etablissement, codePaysEtranger2Etablissement, libellePaysEtranger2Etablissement, dateDebut, etatAdministratifEtablissement, enseigne1Etablissement, enseigne2Etablissement, enseigne3Etablissement, denominationUsuelleEtablissement, activitePrincipaleEtablissement, nomenclatureActivitePrincipaleEtablissement, caractereEmployeurEtablissement, longitude, latitude, geo_score, geo_type, geo_adresse, geo_id, geo_ligne, geo_l4, geo_l5) FROM '../data/geo_siret_"$d".csv' delimiter ',' csv header encoding 'UTF8';"
    echo "POPULATE dep "$d" OK"
done


for d in `seq -w 1 20`; do
    psql -h localhost -p 5434 -U sirene -d sirene -c "\copy siret(siren, nic, siret, statutDiffusionEtablissement, dateCreationEtablissement, trancheEffectifsEtablissement, anneeEffectifsEtablissement, activitePrincipaleRegistreMetiersEtablissement, dateDernierTraitementEtablissement, etablissementSiege, nombrePeriodesEtablissement, complementAdresseEtablissement, numeroVoieEtablissement, indiceRepetitionEtablissement, typeVoieEtablissement, libelleVoieEtablissement, codePostalEtablissement, libelleCommuneEtablissement, libelleCommuneEtrangerEtablissement, distributionSpecialeEtablissement, codeCommuneEtablissement, codeCedexEtablissement, libelleCedexEtablissement, codePaysEtrangerEtablissement, libellePaysEtrangerEtablissement, complementAdresse2Etablissement, numeroVoie2Etablissement, indiceRepetition2Etablissement, typeVoie2Etablissement, libelleVoie2Etablissement, codePostal2Etablissement, libelleCommune2Etablissement, libelleCommuneEtranger2Etablissement, distributionSpeciale2Etablissement, codeCommune2Etablissement, codeCedex2Etablissement, libelleCedex2Etablissement, codePaysEtranger2Etablissement, libellePaysEtranger2Etablissement, dateDebut, etatAdministratifEtablissement, enseigne1Etablissement, enseigne2Etablissement, enseigne3Etablissement, denominationUsuelleEtablissement, activitePrincipaleEtablissement, nomenclatureActivitePrincipaleEtablissement, caractereEmployeurEtablissement, longitude, latitude, geo_score, geo_type, geo_adresse, geo_id, geo_ligne, geo_l4, geo_l5) FROM '../data/geo_siret_751"$d".csv' delimiter ',' csv header encoding 'UTF8';"
    echo "POPULATE dep 751"$d" OK"
done

for d in `seq -w 1 8`; do
    psql -h localhost -p 5434 -U sirene -d sirene -c "\copy siret(siren, nic, siret, statutDiffusionEtablissement, dateCreationEtablissement, trancheEffectifsEtablissement, anneeEffectifsEtablissement, activitePrincipaleRegistreMetiersEtablissement, dateDernierTraitementEtablissement, etablissementSiege, nombrePeriodesEtablissement, complementAdresseEtablissement, numeroVoieEtablissement, indiceRepetitionEtablissement, typeVoieEtablissement, libelleVoieEtablissement, codePostalEtablissement, libelleCommuneEtablissement, libelleCommuneEtrangerEtablissement, distributionSpecialeEtablissement, codeCommuneEtablissement, codeCedexEtablissement, libelleCedexEtablissement, codePaysEtrangerEtablissement, libellePaysEtrangerEtablissement, complementAdresse2Etablissement, numeroVoie2Etablissement, indiceRepetition2Etablissement, typeVoie2Etablissement, libelleVoie2Etablissement, codePostal2Etablissement, libelleCommune2Etablissement, libelleCommuneEtranger2Etablissement, distributionSpeciale2Etablissement, codeCommune2Etablissement, codeCedex2Etablissement, libelleCedex2Etablissement, codePaysEtranger2Etablissement, libellePaysEtranger2Etablissement, dateDebut, etatAdministratifEtablissement, enseigne1Etablissement, enseigne2Etablissement, enseigne3Etablissement, denominationUsuelleEtablissement, activitePrincipaleEtablissement, nomenclatureActivitePrincipaleEtablissement, caractereEmployeurEtablissement, longitude, latitude, geo_score, geo_type, geo_adresse, geo_id, geo_ligne, geo_l4, geo_l5) FROM '../data/geo_siret_97"$d".csv' delimiter ',' csv header encoding 'UTF8';"
    echo "POPULATE dep 97"$d" OK"
done

echo "Creating index on siret column"
psql -h localhost -p 5434 -U sirene -d sirene -c "CREATE INDEX siret_siret ON siret (siret);"
echo "Creating index on siren column"
psql -h localhost -p 5434 -U sirene -d sirene -c "CREATE INDEX siret_siren ON siret (siren);"
echo "Creating index on codeCommuneEtablissementString column"
psql -h localhost -p 5434 -U sirene -d sirene -c "CREATE INDEX siret_codeCommuneEtablissement ON siret (codeCommuneEtablissement);"
echo "Creating index on reg column"
psql -h localhost -p 5434 -U sirene -d sirene -c "CREATE INDEX siret_reg ON siret (reg);"
echo "Creating index on dep column"
psql -h localhost -p 5434 -U sirene -d sirene -c "CREATE INDEX siret_dep ON siret (dep);"
echo "Creating index on arr column"
psql -h localhost -p 5434 -U sirene -d sirene -c "CREATE INDEX siret_arr ON siret (arr);"
echo "index created"

