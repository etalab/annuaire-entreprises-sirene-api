FROM postgres:12

WORKDIR /srv/sirene/

RUN  apt-get update \
  && apt-get install -y wget \
  && apt-get install -y unzip \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /tmp/data/

EXPOSE 5432

HEALTHCHECK --interval=60s --timeout=3s \
  CMD psql -U $POSTGRES_USER -d $POSTGRES_DB -c "SELECT * FROM get_etablissement('');"