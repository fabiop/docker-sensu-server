#!/bin/bash 

/setup.sh

/etc/init.d/postfix start

/usr/bin/supervisord
