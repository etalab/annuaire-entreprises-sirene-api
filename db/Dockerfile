FROM postgres:12

WORKDIR /srv/sirene/

RUN  apt-get update \
  && apt-get install -y wget \
  && apt-get install -y unzip \
  && rm -rf /var/lib/apt/lists/*

ADD ./scripts ./scripts

RUN mkdir -p /tmp/data/

RUN ./scripts/0_get_last_siren_data.sh

RUN cd /tmp/data && unzip -o StockUniteLegale_utf8.zip

RUN ./scripts/1_get_last_siret_data.sh

EXPOSE 5432
