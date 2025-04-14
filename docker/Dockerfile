FROM frappe/bench:v5.24.1

ENV SHELL=/bin/bash

COPY . /workspace/

ARG NODE_VERSION_DEVELOP
ENV NVM_DIR=/home/frappe/.nvm
ENV PATH="${NVM_DIR}/versions/node/v${NODE_VERSION_DEVELOP}/bin/:${PATH}"

RUN bench init --skip-redis-config-generation frappe-bench

WORKDIR /home/frappe/frappe-bench

RUN bench get-app erpnext && bench get-app hrms