mkdir -p /var/lib/postgresql/files
cd /var/lib/postgresql/files && wget https://files.data.gouv.fr/insee-sirene/StockUniteLegale_utf8.zip
cd /var/lib/postgresql/files && unzip -o StockUniteLegale_utf8.zip
