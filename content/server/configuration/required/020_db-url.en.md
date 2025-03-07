+++
title = "Database URL"
slug = "db-url"
weight = 20
+++

> The "db_url" configuration does not support hot reloading. You will need to restart the server after modifying it.

BOMnipotent Server is your gateway for providing supply chain security data and managing access to it. The data itself is stored in a SQL database.

> At the moment, only [PostgreSQL](https://www.postgresql.org/) is supported as a driver.

This database can in principle run in the same environment, in a different container, or on a remote server. BOMnipotent needs to be taught how to reach it. The parameter for providing this information in the config file is "db_url", and the syntax is the following:
```toml
db_url = "<driver>://<user>:<password>@<domain>:<port>/<database>"
```
BOMnipotent will be cross with you if the string you provide does not adhere to this format.

An actual entry could for example be
```toml
db_url = "postgres://bomnipotent_user:${BOMNIPOTENT_DB_PW}@bomnipotent_db:5432/bomnipotent_db"
```
Let's break this down:
- The driver is "postgres", which is the only driver currently supported.
- The username is "bomnipotent_user", because this is the value that was provided to PostgreSQL during the setup.
- The password is read from the external variable "BOMNIPOTENT_DB_PW", which may be provided via environment or .env file. You could also store it in the config file directly, but this is considered bad practice.
- The domain is "bomnipotent_db", which is the name of the docker container running the database. For a database in the same environment this would be "localhost", and for an external database it would be some other domain or IP address.
- The port is 5432, which is the default port that the PostgreSQL listens to. In this case the docker container is in the same docker network as the BOMnipotent Server container. Without this direct connection, you would need to map this internal port to an arbitrary external port in the docker setup, and provide this external port in the config.
- The database itself is also called "bomnipotent_db", because this is the value that was provided to PostgreSQL during the setup.

If BOMnipotent Server cannot reach the database, it will let you know in the logs.
