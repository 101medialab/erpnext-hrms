#!/bin/bash

cd /home/frappe/frappe-bench

site_name="erpnext-hrms.local"
db_name="erpnext_hrms_local"
redis_host="redis://redis:6379"

if [ -d "/home/frappe/frappe-bench/sites/$site_name" ]; then
    echo "$site_name already exists, skipping init"
    bench use $site_name
else
    echo "Initializing $site_name..."
    bench set-mariadb-host mariadb
    bench set-redis-cache-host $redis_host
    bench set-redis-queue-host $redis_host
    bench set-redis-socketio-host $redis_host

    sed -i '/redis/d' ./Procfile
    sed -i '/watch/d' ./Procfile

    bench new-site $site_name --db-name $db_name --db-password 101medialab --admin-password admin --db-root-password 101medialab

    bench use $site_name

    bench install-app hrms
    bench set-config developer_mode 1
    bench enable-scheduler
fi

bench clear-cache
bench start