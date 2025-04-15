#!/bin/bash

cd /home/frappe/frappe-bench

if [ -d "/home/frappe/frappe-bench/sites/$SITE_NAME" ]; then
    echo "$SITE_NAME already exists, skipping init"
    bench use $SITE_NAME
else
    echo "Initializing $SITE_NAME..."
    bench set-mariadb-host mariadb
    bench set-redis-cache-host $REDIS_HOST
    bench set-redis-queue-host $REDIS_HOST
    bench set-redis-socketio-host $REDIS_HOST

    sed -i '/redis/d' ./Procfile
    sed -i '/watch/d' ./Procfile

    bench new-site $SITE_NAME --db-name $DB_NAME --db-password $DB_PASSWORD --db-root-username $INTERMEDIATE_DB_USERNAME --db-root-password $INTERMEDIATE_DB_PASSWORD --admin-password admin

    bench use $SITE_NAME

    bench install-app hrms
    bench set-config developer_mode 1
    bench enable-scheduler
fi

bench clear-cache
bench start