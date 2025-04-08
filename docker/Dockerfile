FROM frappe/bench:latest

ENV SHELL=/bin/bash

COPY . /workspace/

ARG NODE_VERSION_DEVELOP
ENV NVM_DIR=/home/frappe/.nvm
ENV PATH="${NVM_DIR}/versions/node/v${NODE_VERSION_DEVELOP}/bin/:${PATH}"

RUN bench init --skip-redis-config-generation frappe-bench

WORKDIR /home/frappe/frappe-bench

RUN bench set-redis-cache-host redis:6379 && bench set-redis-queue-host redis:6379 && bench set-redis-socketio-host redis:6379

RUN sed -i '/redis/d' ./Procfile && sed -i '/watch/d' ./Procfile

RUN bench get-app erpnext && bench get-app hrms

# Not used. Converted into RUN commands.
#RUN bash /workspace/init.sh