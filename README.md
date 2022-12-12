# PgBouncer Docker container

## Influenced repositories
- https://github.com/edoburu/docker-pgbouncer
- https://github.com/mbentley/dockerfiles

## Used versions
- [alpine:3.16](https://hub.docker.com/_/alpine)
- [pgBouncer 1.17.0](https://github.com/pgbouncer/pgbouncer/releases/tag/pgbouncer_1_17_0)

## Supported setup parameter
| Env variable | Default value | Example value | Required |
|:------------:|:-------------:|:-------------:|:--------:|
| PG_ENV_POSTGRESQL_USER |  | pgbouncer | Yes |
| PG_ENV_POSTGRESQL_PASS |  | pgbouncer | Yes |
| PG_PORT_5432_TCP_ADDR |  | localhost  | No |
| PG_PORT_5432_TCP_PORT |  | 5432 | No |
| PG_ENV_POSTGRESQL_MAX_CLIENT_CONN | 10000 | 10000 | No |
| PG_ENV_POSTGRESQL_DEFAULT_POOL_SIZE | 400 | 400 | No |
| PG_ENV_POSTGRESQL_SERVER_IDLE_TIMEOUT | 240 | 240 | No |
| PG_ENV_POSTGRESQL_POOL_MODE | session | session | No |

## Functionality
The run script creates automatically the corresponding configuration, add the set the ```PG_ENV_POSTGRESQL_USER``` variable as stats_user inside the PgBouncer configuration. After the preparation step, the run script starts pgbouncer automatically and the container bound the port ```6432``` to share the PgBouncer service.


## Docker-compose example

```yaml
version: '3'

services:
  pgbouncer:
    image: z9pascal/pgbouncer
    environment:
      - PG_ENV_POSTGRESQL_USER=pgbouncer
      - PG_ENV_POSTGRESQL_PASS=pgbouncer
    ports:
      - "6432:6432"
```

## Contribution

If you would like to contribute, have an improvement request, or want to make a change inside the code, please open a pull request.

## Support

If you need support, or you encounter a bug, please don't hesitate to open an issue.

## Donations

If you would like to support my work, I ask you to take an unusual action inside the open source community. Donate the money to a non-profit organization like Doctors Without Borders or the Children's Cancer Aid. I will continue to build tools because I like it and it is my passion to develop and share applications.

## License

This product is available under the Apache 2.0 [license](LICENSE).
