#!/bin/bash

DB_nominatim="/var/lib/postgresql/11/main"
photon_data="/app/photon_data"

echo "Wait for other services"
/wait
echo "Check if we need to install first"
if [ ! "$(ls -A $photon_data/elasticsearch)" ] || [ "$(ls -A $DB_nominatim/base)" ] ; then
    echo "Need to install(import) first"  
	echo "Clearing old data"
	rm -rf $DB_nominatim/*
	rm -rf $photon_data/*
    echo "Running import Nominatim script"
    /bin/bash /app/init_nominatim.sh /map.osm.pbf 4
	echo "Starting nominatim"
	service postgresql start
	echo "Running import"
	java -jar /app/photon.jar -nominatim-import -host 127.0.0.1 -port 5432 -user nominatim -password password1234 -languages en
	echo "Stopping nominatim"
	service postgresql stop
	echo "Deleting nominatim data"
	rm -rf $DB_nominatim/*	
	echo "Ready to work"
else
    echo "Installed already, skip to run stage"	
fi
echo "Running photon"
java -jar /app/photon.jar
