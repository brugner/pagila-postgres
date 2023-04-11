## PURPOSE
To merely practice SQL and learn Postgres.

## PRE-REQUISITES
You must have [Docker](https://docs.docker.com/) installed.

## INSTALLATION

1. Open a terminal
2. Run `git clone https://github.com/brugner/pagila-postgres`
3. Run `cd pagila-postgres`
4. Run `docker pull postgres` to get the latest image
5. Run a container: `docker run --name pagila_postgresql -e POSTGRES_USER=za -e POSTGRES_PASSWORD=only_for_dev -p 5432:5432 -v /data:/var/lib/postgresql/data -d postgres`
6. Connect to the continer and create the database: `docker exec -it pagila_postgresql psql -U za -W postgres`

```
psql (15.2 (Debian 15.2-1.pgdg110+1))
Type "help" for help.

postgres=# CREATE DATABASE pagila;
postgres-# CREATE DATABASE
postgres=\q
```

7. Create all schema objects: `cat pagila-schema.sql | docker exec -i pagila_postgresql psql -U za -d pagila`
8. Insert all data: `cat pagila-data.sql | docker exec -i pagila_postgresql psql -U za -d pagila`
9. Done! Connect using pgAdming or run: `docker exec -it pagila_postgresql psql -U za -W -d pagila`

## SOURCE
Based on [Pagila](https://github.com/devrimgunduz/pagila).