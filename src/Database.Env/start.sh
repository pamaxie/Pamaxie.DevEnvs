#!/bin/bash

#Start our redis server
redis-server /etc/redis/redis.conf

#Start our postgres server
su - postgres -c '/usr/lib/postgresql/12/bin/postgres -D /var/lib/postgresql/12/main'