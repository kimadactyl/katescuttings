# Deploying Kate's Cuttings with Kamal

Kate's Cuttings is deployed using [Kamal 2](https://kamal-deploy.org/) to Hetzner Cloud.

## Prerequisites

On your **local machine**:

- Ruby (see `.ruby-version`)
- Kamal: `gem install kamal` (or use the bundled version via `bundle exec kamal`)

On the **server**:

- Ubuntu 22.04+ (Kamal installs Docker automatically on first setup)
- SSH access as root with key-based authentication

## Server provisioning

### 1. Create a server

Create a Hetzner Cloud server (CX22 or similar) with Ubuntu 22.04+. Note the IP address.

### 2. Basic server hardening

```sh
ssh root@SERVER_IP

# Firewall — allow only SSH, HTTP, HTTPS
ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable

# Automatic security updates
apt update && apt install -y unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades

# Disable password auth (ensure your SSH key is already added)
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart ssh
```

### 3. Configure Cloudflare DNS

Add an **A record** pointing to the server IP with **Proxy status: Proxied** (orange cloud):

| Type | Name               | Content       | Proxy   |
| ---- | ------------------ | ------------- | ------- |
| A    | `katescuttings.net` | `<server IP>` | Proxied |

SSL is handled by Let's Encrypt via kamal-proxy. Cloudflare SSL/TLS encryption mode should be set to **Full (Strict)**.

## Kamal setup

### 1. Configure secrets

Set these as GitHub repository secrets (used by the deploy workflow):

- `KAMAL_REGISTRY_PASSWORD` — GitHub personal access token with `write:packages` scope
- `RAILS_MASTER_KEY` — from `config/master.key`
- `POSTGRES_PASSWORD` — strong random password for the database
- `GOOGLE_CLIENT_ID` / `GOOGLE_CLIENT_SECRET` — for admin OAuth login

### 2. First deploy

```sh
# This installs Docker, sets up the database, builds and pushes the image,
# and starts the app with kamal-proxy handling SSL.
kamal setup
```

### 3. Verify

```sh
kamal app details
curl -I https://katescuttings.net
```

## Ongoing operations

```sh
# Deploy latest code (also happens automatically on push to main)
kamal deploy

# View logs
kamal logs

# Open a Rails console
kamal console

# Reboot the database accessory (e.g. after config changes)
kamal accessory reboot db
```

## Security notes

- PostgreSQL is bound to `127.0.0.1` only (not exposed to the internet)
- The app connects to the database via Docker's internal network (`katescuttings-db` hostname)
- UFW firewall should only allow ports 22, 80, and 443
- SSH password authentication should be disabled
- Automatic security updates should be enabled via `unattended-upgrades`
- Container memory limits are set to 512MB for both the app and database
