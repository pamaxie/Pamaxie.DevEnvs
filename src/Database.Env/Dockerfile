FROM ubuntu:20.04

#Set our timezone information and use the noninteractive enviorement variable to tell certain programs we are non interactive
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Minsk
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#Install the postgres package
RUN apt-get update && apt-get install -y postgresql-12 postgresql-contrib-12

USER postgres

#Execute the rest of our postgres commands as the postgres user
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
    createdb -O docker docker

#Configure the postgres DB so we can connect to it externally
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/12/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/12/main/postgresql.conf

#Expose the port 5432 to allow connections to the container
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

#Install our Redis enviorement
#Switch back to root user
USER root

#Install the redis package
RUN apt-get update && apt-get install -y redis-server redis-tools
RUN sed -i "s%searchTerm=supervised no% c searchTerm=supervised systemd%" /etc/redis/redis.conf



EXPOSE 6379

#Add our start script
ADD start.sh /
RUN chmod +x /start.sh


# Set the default command to run when starting the container
CMD ["/start.sh"]