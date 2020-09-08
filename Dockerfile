FROM ubuntu:20.04

# Commands to install Postgresql on older version of ubuntu
# RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
# RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list
# RUN apt-get update -y
# RUN apt-get update && apt-get install -y python-software-properties software-properties-common postgresql-12 postgresql-client-12 postgresql-contrib-12

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y
RUN apt-get install curl npm postgresql -y

# Install nodejs
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
ENV NODE_VERSION v12.18.3
RUN /bin/bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm use --delete-prefix $NODE_VERSION"
RUN echo "node version: " && node --version

WORKDIR /logchimp
RUN pwd && ls
RUN npm install -g yarn
RUN echo "npm version: " RUN npm --version
RUN echo "yarn version: " && yarn --version
COPY . .
RUN yarn install

# Run the rest of the commands as the ``postgres`` user created by the ``postgres-12`` package when it was ``apt-get installed``
USER postgres

# Create a PostgreSQL role and database
RUN /etc/init.d/postgresql start &&\
  psql --command "CREATE USER logchimp_user WITH SUPERUSER PASSWORD 'logchimp_password';" &&\
	psql --command "CREATE DATABASE logchimp_database;"

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/12/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/12/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/12/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
# VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Set the default command to run when starting the container
# CMD ["/usr/lib/postgresql/12/bin/postgres", "-D", "/var/lib/postgresql/12/main", "-c", "config_file=/etc/postgresql/12/main/postgresql.conf"]

# RUN yarn run server:dev
CMD yarn run frontend:dev
