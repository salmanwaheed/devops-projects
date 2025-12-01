# HashiCorp Vault Reference Guide

Vault securely manages **secrets, tokens, credentials, and dynamic values** across systems and clouds.

---

## Core Concepts (Recall Fast)

| Concept | Meaning |
|----------|----------|
| **Init** | Creates master keys & root token. |
| **Unseal** | Unlocks Vault using key shares or auto-unseal (e.g. AWS KMS). |
| **Auth Method** | How users/apps authenticate (`token`, `userpass`, `approle`, `oidc`). |
| **Secret Engine** | Backend that stores or generates secrets (`kv`, `transit`, `aws`, `database`). |
| **Policy (ACL)** | Defines permissions (who can do what). |
| **Token** | Credential used to access Vault. |
| **Lease** | Time-based secret validity (auto-expiry/renew). |
| **Dynamic Secrets** | Auto-created & rotated creds (DB, AWS, etc.). |
| **HA (High Availability)** | Multiple nodes via Raft for redundancy. |
| **Agent** | Auto-auth and inject secrets into apps/configs. |

---

## Common Configuration

### `/etc/vault.d/vault.hcl`

```hcl
listener "tcp" {
  address          = "[::]:8200"
  cluster_address  = "[::]:8201"
  tls_disable      = true
  # tls_cert_file  = "/opt/vault/tls/tls.crt"
  # tls_key_file   = "/opt/vault/tls/tls.key"
}

# Storage (HA - Raft)
storage "raft" {
  path    = "/opt/vault/data"
  node_id = "<NODE_NAME>"

  retry_join {
    leader_api_addr = "http://<LEADER_VM_IP_ADDRESS>:8200"
  }
}

# Auto-Unseal (AWS KMS)
seal "awskms" {
  kms_key_id = "<kms_arn>"
}

ui = true
api_addr      = "http://<VM_IP_ADDRESS>:8200"
cluster_addr  = "http://<VM_IP_ADDRESS>:8201"
cluster_name  = "<CLUSTER_NAME>"
disable_mlock = true
```

### /etc/vault.d/vault.env

```bash
AWS_REGION=<region>
AWS_ACCESS_KEY_ID=<access_key>
AWS_SECRET_ACCESS_KEY=<secret_key>
```

## Common Commands

```bash
vault server -config /etc/vault.d/vault.hcl
vault status

# Initialize & Unseal
vault operator init -key-shares=1 -key-threshold=1
vault operator unseal <key>
vault operator diagnose -config /etc/vault.d/vault.hcl

# Add new node to cluster
vault operator raft join http://<LEADER_VM_IP_ADDRESS>:8200

# Login
vault login -method=token <root_token>
vault login -method=userpass username=<user> password=<pass>
vault token lookup

# Auth methods
vault auth list
vault auth enable userpass
vault write auth/userpass/users/<user> password=<pass> policies=<policy>
vault read auth/userpass/users/<user>
vault list auth/userpass/users
vault auth help <method>

# Secrets (KV)
vault secrets list
vault secrets enable -path=secret kv-v2
vault kv put secret/api <key>=<value> ...
vault kv get -field=<key> secret/api
vault kv list secret
vault kv delete secret/api

# Policies
vault policy list
vault policy write <policy_name> /path/to/<policy>.hcl
vault policy read <policy_name>
vault policy delete <policy_name>

# Dynamic Secrets (MySQL)
vault secrets enable database
vault write database/config/mydb \
  plugin_name=mysql-database-plugin \
  connection_url="{{username}}:{{password}}@tcp(127.0.0.1:3306)/" \
  allowed_roles=myrole \
  username=root \
  password=root

vault write database/roles/myrole \
  db_name=mydb \
  creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}'; GRANT SELECT ON mydb.* TO '{{name}}'@'%';" \
  default_ttl=1h \
  max_ttl=24h

# Dynamic Secrets (MongoDB)
vault write database/config/mongodb \
  plugin_name=mongodb-database-plugin \
  connection_url="mongodb://{{username}}:{{password}}@localhost:27017/admin" \
  allowed_roles=mongorole \
  username=vaultuser \
  password=vaultpass

vault write database/roles/mongorole \
  db_name=mongodb \
  creation_statements='{"db":"mydb","roles":[{"role":"readWrite","db":"mydb"}]}' \
  default_ttl=1h \
  max_ttl=24h

vault read database/creds/myrole
vault list database/roles
vault delete database/config/mydb
```

## Policies (ACL Examples)

```hcl
# admin-policy.hcl
path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# dev-policy.hcl
path "secret/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# readonly-policy.hcl
path "secret/data/api" {
  capabilities = ["read", "list"]
}
```

## Vault Agent / Templates

```bash
# Inject secret into environment variable
export DB_PASSWORD=$(vault kv get -field=password apps/my-creds)
```

### template.hcl
```hcl
{{ with secret "apps/my-creds" }}
DB_USER={{ .Data.data.username }}
DB_PASSWORD={{ .Data.data.password }}
{{ end }}
```

## Useful Environment Variables (~/.bashrc)

```bash
export VAULT_ADDR=http://<VM_IP_ADDRESS>:8200
export VAULT_SKIP_VERIFY=true
export VAULT_TOKEN=<YOUR_TOKEN>
export VAULT_CACERT=$(mkcert -CAROOT)/rootCA.pem
export VAULT_LOG_LEVEL=info
export VAULT_LOG_FILE=/var/log/vault.log
```

## Troubleshooting

| Problem           | Fix                                          |
| ----------------- | -------------------------------------------- |
| Vault is sealed   | `vault operator unseal`                      |
| Permission denied | `vault policy read <policy>`                 |
| Wrong path (KVv2) | Use `secret/data/` not `secret/`             |
| Token expired     | Login again or renew lease                   |
| Cannot connect    | Check `VAULT_ADDR`, port `8200`, or firewall |

## Reset Vault Data (Destroys all data)

```bash
sudo systemctl stop vault
sudo rm -rf /opt/vault/data
sudo mkdir -p /opt/vault/data
sudo chown vault:vault /opt/vault/data
sudo systemctl start vault
```

## References
- https://developer.hashicorp.com/vault/docs
- https://developer.hashicorp.com/vault/tutorials
- https://learn.hashicorp.com/collections/vault/getting-started
