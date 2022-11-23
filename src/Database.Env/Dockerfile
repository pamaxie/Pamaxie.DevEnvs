#/*----------------------*/
#/*--Set base container--*/
#/*----------------------*/
FROM gitpod/workspace-dotnet
#/*----------------------*/

#/*---------------------------------------*/
#/*--Configure our Enviorement Variables--*/
#/*---------------------------------------*/
#Postgres config parameters. Change these however you'd like credentials and the database to be configured
ENV PostgresDbName=pamaxie
ENV PostgresUserName=admin
ENV PostgresPassword=admin
ENV PostgresPort=5432
ENV PamDBAPIToken=PamToken/-//1044848005808660480/-//1044852084576370688/-//CnzR+87+4dg36QK8LNe6dL/LvtFnCv/aRV1/9qGkrwRDTLrRZwC7pePGd+ItxBlNPm11XRrjLMvhRMR0XBK6tw==

#Redis config parameters
ENV RedisPass=admin
#/*--------------------------------------*/

#/*--------------------------------------*/
#/*--Add our Startup and Configuration Scripts to the Container--*/
#/*--------------------------------------*/
ADD start.sh /
RUN sudo chmod +x /start.sh

ADD configure_redis.sh /data/configure_redis.sh
RUN sudo chmod +x /data/configure_redis.sh

COPY configure_db.sql /data/configure_db.sql
RUN sudo chmod +x /data/configure_db.sql
#/*-------------------------------------*/

#/*----------------------------------------------------------------------------*/
#/*--Run some nessecary configuration to tell programs we are non interactive--*/
#/*----------------------------------------------------------------------------*/
#Set our timezone information and use the noninteractive enviorement variable to tell certain programs we are non interactive
ENV sudo DEBIAN_FRONTEND=noninteractive
#ENV sudo TZ=Europe/Minsk
#RUN sudo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && sudo echo $TZ > /etc/timezone

#/*----------------------------------------------------------------------------*/
#/*---------------------------------*/
#/*--Configure our Postgres Server--*/
#/*---------------------------------*/
#Install the postgres package
RUN sudo apt-get update && sudo apt-get install -y postgresql-12 postgresql-contrib-12

USER postgres

#Create our Database Users via the specified env vars
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER ${PostgresUserName} WITH SUPERUSER PASSWORD '${PostgresPassword}';"

#Create our Database Users via the specified env vars
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE DATABASE pamaxie WITH OWNER=${PostgresUserName};"

#Apply our Test Dataset to the Database
RUN /etc/init.d/postgresql start &&\
    psql -d pamaxie < /data/configure_db.sql

#Configure the postgres DB so we can connect to it externally
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/12/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/12/main/postgresql.conf

USER root

#Move configuration files to the folders we use for it
RUN mv /etc/postgresql/12/main/conf.d /var/lib/postgresql/12/main/conf.d
RUN mv /etc/postgresql/12/main/postgresql.conf /var/lib/postgresql/12/main/postgresql.conf
#/*------------------------------*/

RUN sudo apt-get update && apt-get install -y redis-server redis-tools

#/*------------------------------*/
#/*--Configure our Redis Server--*/
#/*------------------------------*/
#Set our default password to admin
RUN sudo sed -i 's/^# requirepass.*/requirepass admin/' /etc/redis/redis.conf

#Set to bind to all addresses
RUN sudo sed -i "s/^bind 127.0.0.1 ::1.*/# bind 127.0.0.1 ::1%/" /etc/redis/redis.conf
RUN sudo sed -i "s/^protected-mode yes/# protected-mode yes/" /etc/redis/redis.conf

#Disable startup logo
RUN sudo sed -i "s/^always-show-logo yes/# always-show-logo yes/" /etc/redis/redis.conf
RUN sudo sed -i "s/^searchTerm=daemonize/# daemonize/" /etc/redis/redis.conf
RUN sudo cat /etc/redis/redis.conf

#Add Testing data to redis server
RUN sudo redis-server /etc/redis/redis.conf &&\
    bash /data/configure_redis.sh

#/*------------------------------*/


#/*--------------Cleanup after ourselves----------------*/
RUN sudo rm /data/configure_db.sql
#/*-----------------------------------------------------*/

# Set the default command to run when starting the container
CMD ["/start.sh"]