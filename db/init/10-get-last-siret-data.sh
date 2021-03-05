for d in `seq -w 1 19` 2A 2B `seq 21 74` `seq 76 95` 98 ""; do
  cd /var/lib/postgresql/files && wget https://files.data.gouv.fr/geo-sirene/last/dep/geo_siret_$d.csv.gz
  gunzip /var/lib/postgresql/files/geo_siret_$d.csv.gz
done
#Cas particulier Paris
for d in `seq -w 1 20`; do
  cd /var/lib/postgresql/files && wget https://files.data.gouv.fr/geo-sirene/last/dep/geo_siret_751$d.csv.gz
  gunzip /var/lib/postgresql/files/geo_siret_751$d.csv.gz
done
#Cas particulier DOM
for d in `seq -w 1 8`; do
  cd /var/lib/postgresql/files && wget https://files.data.gouv.fr/geo-sirene/last/dep/geo_siret_97$d.csv.gz
  gunzip /var/lib/postgresql/files/geo_siret_97$d.csv.gz
done