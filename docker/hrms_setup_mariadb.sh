#!/bin/bash

cd /home/frappe/frappe-bench

bench set-mariadb-host mariadb
bench new-site erpnext-hrms.local --admin-password admin --db-root-password 101medialab

bench use erpnext-hrms.local

bench install-app hrms
bench set-config developer_mode 1
bench enable-scheduler
bench clear-cache
bench start
