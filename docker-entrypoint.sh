#!/bin/bash

set -e

php-fpm --daemonize

exec "$@"