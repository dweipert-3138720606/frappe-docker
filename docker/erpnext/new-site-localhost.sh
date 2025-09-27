#!/bin/env sh

bench new-site --mariadb-user-host-login-scope="%" --admin-password=admin --db-root-username=root --db-root-password=admin --install-app erpnext --set-default localhost
