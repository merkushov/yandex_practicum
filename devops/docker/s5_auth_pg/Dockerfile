FROM postgres:13

COPY devops/docker/s5_auth_pg/docker-postgresql-multiple-databases.sh /docker-entrypoint-initdb.d/docker-postgresql-multiple-databases.sh

RUN echo "SET search_path TO auth,public;" > /root/.psqlrc