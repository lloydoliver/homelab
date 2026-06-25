# authentik_app

The Authentik **app tier** — `server` + `worker` only — deployed via the official
docker-compose on each cluster member (Caddy load-balances the two servers). The
HA data tier (Patroni Postgres, Redis+Sentinel) is **external**; the app reaches it
through the node-local `haproxy_patroni` frontends at `127.0.0.1:5000` (Postgres
leader) and `127.0.0.1:6379` (Redis master). `network_mode: host` lets the
containers see those loopback frontends.

## Why compose, not Incus-native OCI

Authentik's only upstream-tested deploy is docker-compose. Running its multi-process
image as bare Incus OCI application containers is unverified, and this gates the
whole auth layer — so we stay on the supported path (server+worker in a nesting
container per node) while still distributing across tc1/tc2 for HA.

## Why a Redis HAProxy frontend

**Authentik does not support Redis Sentinel** — it only accepts a single
`AUTHENTIK_REDIS__HOST`. So `haproxy_patroni` runs a `role:master` Redis frontend
on each app node; Sentinel still drives failover, Authentik just uses the local
endpoint. See `haproxy_patroni`'s `haproxy_redis_backends`.

## Secrets (SOPS)

`authentik_secret_key`, `authentik_pg_password`, `authentik_redis_password`.

## Pin the image

`authentik_image` defaults to a placeholder — set it to a confirmed current stable
tag before applying.
