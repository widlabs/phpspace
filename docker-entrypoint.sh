#!/bin/bash

set -e

mkdir -p "/run/php-fpm"
php-fpm --daemonize

exec "$@"