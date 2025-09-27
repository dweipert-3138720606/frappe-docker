FROM surnet/alpine-wkhtmltopdf:3.22.0-0.12.6-small AS wkhtmltopdf


FROM python:3-alpine AS bench

ARG BENCH_GIT_REPO=https://github.com/frappe/bench
ARG BENCH_GIT_BRANCH=v5.x

COPY --from=wkhtmltopdf /bin/wkhtmltopdf /bin/wkhtmltopdf

RUN apk add --update \
  git sudo \
  vim neovim \
  nodejs npm

RUN chmod u+s /usr/bin/crontab \
  && touch /etc/crontabs/frappe

RUN adduser -D frappe frappe \
  && addgroup frappe wheel \
  && echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel

WORKDIR /home/frappe

RUN npm install -g \
  yarn

USER frappe

ENV PATH=/home/frappe/.local/bin:$PATH
ENV BENCH_DEVELOPER=1

RUN git clone ${BENCH_GIT_REPO} --depth 1 -b ${BENCH_GIT_BRANCH} .bench \
  && pip install --no-cache-dir --user -e .bench


FROM bench AS frappe

ARG FRAPPE_GIT_BRANCH=version-15

ARG DB_HOST=db
ARG DB_PORT=3306
ARG REDIS_CACHE=redis-cache:6379
ARG REDIS_QUEUE=redis-queue:6379
ARG SOCKETIO_PORT=9000

USER root
RUN apk add --update \
  build-base linux-headers pkgconf \
  bash mariadb-connector-c-dev mariadb-client

USER frappe

RUN bench init frappe-bench --version=${FRAPPE_GIT_BRANCH} --skip-redis-config-generation --verbose

WORKDIR /home/frappe/frappe-bench

RUN bench config set-common-config -c db_host ${DB_HOST} \
  && bench config set-common-config -c db_port ${DB_PORT} \
  && bench config set-common-config -c redis_cache "REDIS_CACHE" \
  && bench config set-common-config -c redis_queue "REDIS_QUEUE" \
  && bench config set-common-config -c redis_socketio "REDIS_CACHE" \
  && bench config set-common-config -c socketio_port ${SOCKETIO_PORT}

RUN sed -i "s#REDIS_CACHE#redis://${REDIS_CACHE}#" /home/frappe/frappe-bench/sites/common_site_config.json \
  && sed -i "s#REDIS_QUEUE#redis://${REDIS_QUEUE}#" /home/frappe/frappe-bench/sites/common_site_config.json

#ADD new-site-localhost.sh /home/frappe/.local/bin


FROM frappe AS erpnext

ARG ERPNEXT_GIT_REPO=https://github.com/frappe/erpnext
ARG ERPNEXT_GIT_BRANCH=version-15

RUN bench get-app --branch=${ERPNEXT_GIT_BRANCH} ${ERPNEXT_GIT_REPO}
