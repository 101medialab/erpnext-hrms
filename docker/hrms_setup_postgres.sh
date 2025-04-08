#!/bin/bash

cd /home/frappe/frappe-bench

bench new-site erpnext-hrms.local --db-type postgres --db-name erpnext-hrms --db-user erpnext-hrms --db-password 101medialab --admin-password admin --db-host postgres

bench use erpnext-hrms.local

bench install-app hrms
bench set-config developer_mode 1
bench enable-scheduler
bench clear-cache
bench start
