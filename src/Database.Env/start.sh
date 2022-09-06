#!/bin/bash

#Start our postgres server
/usr/lib/postgresql/12/bin/postgres -D /var/lib/postgresql/12/main -c config_file=/etc/postgresql/12/main/postgresql.conf

#Start our redis server
redis-server /etc/redis/redis.conf