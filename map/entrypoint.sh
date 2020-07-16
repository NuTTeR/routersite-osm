#!/bin/bash

DB_DIR="/var/lib/postgresql/10/main"

echo "Wait for other services"
/wait
echo "Check if we need to install first"
if ! [ "$(ls -A $DB_DIR)" ]; then
    echo "Need to install(import) first"
    echo "Setting correct ownership"
    chown postgres: $DB_DIR
    chown renderer: /var/lib/mod_tile
    echo "Creating empty DB"
    sudo -u postgres /usr/lib/postgresql/10/bin/initdb -D $DB_DIR -E 'UTF-8'    
    echo "Running import script"    
    /bin/bash /run.sh import
else
    echo "Installed already, skip to run stage"
fi

echo "Running osm tiles server"
/bin/bash /run.sh run