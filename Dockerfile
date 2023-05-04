FROM alpine:3.17
ARG VERSION=1.19.0
MAINTAINER Pascal Zimmermann <ZPascal>
LABEL application="PgBouncer" \
      description="Base alpine linux container image + PgBouncer" \
      version="1.19.0" \
      lastModifiedBy="Pascal Zimmermann" \
      lastModifiedOn="2023-05-04"

ENV PG_ENV_POSTGRESQL_MAX_CLIENT_CONN 10000
ENV PG_ENV_POSTGRESQL_DEFAULT_POOL_SIZE 400
ENV PG_ENV_POSTGRESQL_SERVER_IDLE_TIMEOUT 240
ENV PG_ENV_POSTGRESQL_POOL_MODE session

ADD run.sh /usr/local/bin/run

RUN apk --update add autoconf autoconf-doc automake udns udns-dev curl gcc libc-dev libevent libevent-dev libtool \
    make openssl-dev pkgconfig postgresql-client && \
    # Download the PgBouncer version, unpack, compile and install
    curl -o  /tmp/pgbouncer-$VERSION.tar.gz \
    -L https://pgbouncer.github.io/downloads/files/$VERSION/pgbouncer-$VERSION.tar.gz && \
    cd /tmp && tar xvfz /tmp/pgbouncer-$VERSION.tar.gz && cd pgbouncer-$VERSION && \
    ./configure --prefix=/usr --with-udns && make && mv pgbouncer /usr/bin && \
    # Make run script and pgbouncer executable
    chmod +x /usr/local/bin/run /usr/bin/pgbouncer && \
    # Create the necessary folders
    mkdir -p /etc/pgbouncer /var/log/pgbouncer /var/run/pgbouncer && \
    chown -R postgres:postgres /var/run/pgbouncer /etc/pgbouncer /var/log/pgbouncer && \
    # Cleanup
    cd /tmp && \
    rm -rf /tmp/pgbouncer*  && \
    apk del --purge autoconf autoconf-doc automake udns-dev curl gcc libc-dev libevent-dev \
    libtool make libressl-dev pkgconfig

EXPOSE 6432
CMD ["/usr/local/bin/run"]
