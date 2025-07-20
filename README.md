# 🚧 W.I.P LogChimp Docker image

> This repository is archieved and no longer maintained.
> LogChimp Docker images source files are moved to [logchimp/logchimp](https://github.com/logchimp/logchimp) repository.

![Docker](https://github.com/logchimp/docker/workflows/Docker/badge.svg?branch=master)

### Deploy LogChimp site

Make sure to run the scripts in order from top to bottom.

Create a docker network which is shared between database and LogChimp app.

```sh
docker network create -d bridge logchimp_network
```

You can change the values of environment variable.

```sh
docker run -d \
	--name db \
	-p 5000:5432 \
	--network=logchimp_network \
	-e POSTGRES_DB=logchimp_db \
	-e POSTGRES_USER=logchimp_user \
	-e POSTGRES_PASSWORD=logchimp_password \
	postgres:12.4
```

```sh
docker run -d \
	--name lc \
	-p 8080:8080 \
	-p 3000:3000 \
	--network=logchimp_network \
	-e PG_HOST=db \
	-e PG_USER=logchimp_user \
	-e PG_DATABASE=logchimp_db \
	-e PG_PASSWORD=logchimp_password \
	-e PG_PORT=5432 \
	-e SECRET_KEY=Fig8=Diq1 \
	logchimp
```
