#!/bin/bash

cd /home/frappe/frappe-bench

bench clear-cache

bench get-app erpnext_hrms_addons https://github.com/101medialab/erpnext-hrms-addons

bench install-app erpnext_hrms_addons

bench restart