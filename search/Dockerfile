FROM ubuntu:disco

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

## Add the wait script to the image
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.6.0/wait /wait
RUN chmod +x /wait

RUN apt-get -y update -qq && \
    apt-get -y install locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    apt-get install -y build-essential cmake g++ libboost-dev libboost-system-dev \
    libboost-filesystem-dev libexpat1-dev zlib1g-dev libxml2-dev\
    libbz2-dev libpq-dev libgeos-dev libgeos++-dev libproj-dev \
    postgresql-server-dev-11 postgresql-11-postgis-2.5 postgresql-contrib-11 \
    apache2 php php-pgsql libapache2-mod-php php-pear php-db \
    php-intl git curl wget sudo \
    python3-pip libboost-python-dev \
	openjdk-11-jdk
	
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app

# Configure postgres
RUN echo "host all  all    0.0.0.0/0  trust" >> /etc/postgresql/11/main/pg_hba.conf && \
    echo "listen_addresses='*'" >> /etc/postgresql/11/main/postgresql.conf

# Nominatim install
ENV NOMINATIM_VERSION v3.3.0
RUN git clone --recursive https://github.com/openstreetmap/Nominatim ./src
WORKDIR /app/src
RUN git checkout tags/$NOMINATIM_VERSION && git submodule update --recursive --init
RUN mkdir build && cd build && cmake .. && make

WORKDIR /app

# Load initial data
RUN curl http://www.nominatim.org/data/country_grid.sql.gz > /app/src/data/country_osm_grid.sql.gz

# Load photon
ADD https://github.com/komoot/photon/releases/download/0.3.1/photon-0.3.1.jar /app/photon.jar

COPY init_nominatim.sh /app/init_nominatim.sh
COPY entrypoint.sh /
