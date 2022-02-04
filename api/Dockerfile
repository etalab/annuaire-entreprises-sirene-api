
FROM debian:buster

ARG POSTGREST_VERSION

# Install postgrest
RUN BUILD_DEPS="curl ca-certificates xz-utils" && \
    apt-get -qq update && \
    apt-get -qq install -y --no-install-recommends $BUILD_DEPS && \
    cd /tmp && \
    curl -SLO https://github.com/PostgREST/postgrest/releases/download/${POSTGREST_VERSION}/postgrest-${POSTGREST_VERSION}-linux-x64-static.tar.xz && \
    tar -xJvf postgrest-${POSTGREST_VERSION}-linux-x64-static.tar.xz && \
    mv postgrest /usr/local/bin/postgrest && \
    cd / && \
    apt-get -qq purge --auto-remove -y $BUILD_DEPS && \
    apt-get -qq clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get install -y curl

RUN apt-get update && apt-get install -y gnupg2

RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main 12' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

RUN apt-get update && apt-get install -y postgresql-client-12


COPY postgrest.conf /etc/postgrest.conf

ENV PGRST_DB_URI= \
    PGRST_DB_SCHEMA=public \
    PGRST_DB_ANON_ROLE= \
    PGRST_DB_POOL=100 \
    PGRST_DB_POOL_TIMEOUT=1 \
    PGRST_DB_EXTRA_SEARCH_PATH=public \
    PGRST_SERVER_HOST=*4 \
    PGRST_SERVER_PORT=3000 \
    PGRST_OPENAPI_SERVER_PROXY_URI= \
    PGRST_JWT_SECRET= \
    PGRST_SECRET_IS_BASE64=false \
    PGRST_JWT_AUD= \
    PGRST_MAX_ROWS= \
    PGRST_PRE_REQUEST= \
    PGRST_ROLE_CLAIM_KEY=".role" \
    PGRST_ROOT_SPEC= \
    PGRST_RAW_MEDIA_TYPES=

RUN groupadd -g 1000 postgrest && \
    useradd -r -u 1000 -g postgrest postgrest && \
    chown postgrest:postgrest /etc/postgrest.conf

USER 1000

# PostgREST reads /etc/postgrest.conf so map the configuration
# file in when you run this container
EXPOSE 3000

HEALTHCHECK --interval=1s --timeout=3s \
  CMD PGPASSWORD=$POSTGRES_PASSWORD psql -h $POSTGRES_DB_HOST -p 5432 -U $POSTGRES_USER -d $POSTGRES_DB -c "select * from etablissements_siren limit 1;"
CMD exec postgrest /etc/postgrest.conf
