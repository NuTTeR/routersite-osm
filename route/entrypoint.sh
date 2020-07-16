#!/bin/bash

#map name to check
file="map"

echo "Install check"
if [ -f "/osm-data/$file.osrm" ]
then
    echo "Installed already, skip to run stage"
else
    echo "Need to install (unpack) map"    
    echo "If this stage fails, consider get bigger swap file and\or bigger RAM"
    echo "Extracting data"
    osrm-extract -p /opt/car.lua /osm-data/$file.osm.pbf
    echo "Contract data"
    osrm-contract /osm-data/$file.osrm
fi
echo "OSRM start"
osrm-routed /osm-data/$file.osrm --max-table-size=1000 --max-viaroute-size=50000