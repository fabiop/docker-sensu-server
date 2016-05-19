#!/bin/bash

# Set defaults if vars are not defined at run time
# to define, use
# docker run --rm -e ALERT_EMAIL=foo.bar@gmail.com -e REDIS_SERVER=redis.foo.com -e REDIS_PORT=1111 -e RABBIT_SERVER=rabbit.foo.com -e RABBIT_PORT=2222 -e RABBIT_VHOST=/Sensu -e RABBIT_USER=sensu -e RABBIT_PASS=pass sensu-server-mailer
# or in docker-compose.yml
#
# core-sensu:
#   image: fabiop/sensu-server-mailer
#   restart: unless-stopped
#   container_name: core-sensu
#   ports:
#     - "5671:5671"
#     - "5672:5672"
#     - "15672:15672"
#     - "3000:3000"
#     - "4567:4567"
#   environment:
#     - ALERT_EMAIL=blabla@uswitch.com

export ALERT_EMAIL=${ALERT_EMAIL:-dev@null.com}
export REDIS_SERVER=${REDIS_SERVER:-localhost}
export REDIS_PORT=${REDIS_PORT:-6379}
export RABBIT_SERVER=${RABBIT_SERVER:-localhost}
export RABBIT_PORT=${RABBIT_PORT:-5671}
export RABBIT_VHOST=${RABBIT_VHOST:-/sensu}
export RABBIT_USER=${RABBIT_USER:-sensu}
export RABBIT_PASS=${RABBIT_PASS:-password}

cat /etc/sensu/config.json.template | envsubst > /etc/sensu/config.json




