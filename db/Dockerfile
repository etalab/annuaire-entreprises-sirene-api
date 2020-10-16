FROM postgres:12

WORKDIR /srv/sirene/

RUN  apt-get update \
  && apt-get install -y wget \
  && apt-get install -y unzip \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /tmp/data/

EXPOSE 5432
