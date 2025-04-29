#!/bin/bash

TIMEOUT=5         # Timeout for connection attempts in seconds
MAX_RETRIES=10    # Maximum number of connection attempts
RETRY_INTERVAL=2  # Time to wait between retries in seconds

cd /home/frappe/frappe-bench

attempt=0

echo "Checking if MySQL/MariaDB is ready on ${MARIADB_HOST}..."

while true; do
  attempt=$((attempt + 1))

  # Attempt to connect to MySQL/MariaDB using mysql command
  if mysql -h "$MARIADB_HOST" -P 3306 -u root -p"$MARIADB_ROOT_PASSWORD" -e "SELECT 1;" >/dev/null 2>&1; then
    echo "MySQL/MariaDB is ready after $attempt attempt(s)."
    break
  else
    if [ "$attempt" -ge "$MAX_RETRIES" ]; then
      echo "Failed to connect to MySQL/MariaDB after $MAX_RETRIES attempts. Exiting."
      exit 1
    fi
    echo "MySQL/MariaDB not yet ready (attempt $attempt of $MAX_RETRIES). Retrying in $RETRY_INTERVAL seconds..."
    sleep "$RETRY_INTERVAL"
  fi
done

if [ -d "/home/frappe/frappe-bench/sites/$SITE_NAME" ]; then
    echo "$SITE_NAME already exists, skipping init"
    bench use $SITE_NAME
else
    echo "Creating Intermediate User..."
    mysql -h $MARIADB_HOST -u root -p$MARIADB_ROOT_PASSWORD < /workspace/create_intermediate_sql_user.sql

    echo "Initializing $SITE_NAME..."
    bench set-mariadb-host $MARIADB_HOST
    bench set-redis-cache-host $REDIS_HOST
    bench set-redis-queue-host $REDIS_HOST
    bench set-redis-socketio-host $REDIS_HOST

    sed -i '/redis/d' ./Procfile
    sed -i '/watch/d' ./Procfile

    bench new-site $SITE_NAME --db-name $DB_NAME --db-password $DB_PASSWORD --db-root-username $INTERMEDIATE_DB_USERNAME --db-root-password $INTERMEDIATE_DB_PASSWORD --admin-password admin

    bench use $SITE_NAME

    bench install-app hrms
    bench set-config developer_mode 1
    bench set-config restart_supervisor_on_update 1
    bench set-config restart_systemd_on_update 1
    bench enable-scheduler
fi

bench clear-cache
bench start