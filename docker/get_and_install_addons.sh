#!/bin/bash

cd /home/frappe/frappe-bench

bench clear-cache

rm -rf ./apps/erpnext_hrms_addons

bench get-app erpnext_hrms_addons https://github.com/101medialab/erpnext-hrms-addons

bench clear-cache

bench install-app erpnext_hrms_addons

bench migrate

bench clear-cache

bench restart