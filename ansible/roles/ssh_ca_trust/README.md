# ssh_ca_trust

Makes a host trust the OpenBao SSH CA for **user certificates**. With it, a user who
holds a short-lived cert signed by the CA (principals including their username) can
SSH in — no per-host key distribution.

## Safe by construction

- **Additive only**: drops a `TrustedUserCAKeys` directive via `sshd_config.d/`. It
  does not touch `PubkeyAuthentication`, `AuthorizedKeysFile`, or
  `AuthenticationMethods`, so existing key-based logins (the `ansible` user) keep
  working exactly as before.
- **Validated**: the handler runs `sshd -t` and only reloads on success; a bad config
  fails the run and leaves the running sshd on its last-good config. `reload` (not
  `restart`) never drops live connections.

## Data

`ssh_ca_public_key` (the CA public key) is site data, set in the deploy. Empty = the
role is a no-op. Pairs with the `sssd` role (identity + the `ssh-users` access gate);
this role is the authentication half, that one is identity/authorisation.
