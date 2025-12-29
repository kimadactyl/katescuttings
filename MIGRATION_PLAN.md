# KatesCuttings Migration & Upgrade Plan

## Current State

| Component | Current | Notes |
|-----------|---------|-------|
| Ruby | 3.3.6 | Recent |
| Rails | 7.1.x | Recent, could upgrade to 8.x |
| Database | PostgreSQL | On Digital Ocean |
| Assets | Webpacker 5 | Legacy, needs migration |
| JS Framework | Turbolinks | Legacy, needs Turbo |
| Image Storage | Active Storage (local disk) | ~stored in `storage/` dir |
| Auth | HTTP Basic (ENV vars) | Simple but not great UX |
| Deployment | Unknown/manual | No config files found |

## Phase 1: Git Housekeeping ✓ COMPLETE

- [x] **1.1** Rename `master` branch to `main` locally
- [x] **1.2** Update default branch on GitHub to `main`
- [x] **1.3** Delete old `master` branch on remote

## Phase 2: Rails Modernization ✓ COMPLETE

- [x] **2.1** Migrate from Webpacker to importmaps
- [x] **2.2** Migrate from Turbolinks to Turbo
- [x] **2.3** Created Stimulus lightbox controller
- [x] **2.4** Updated views with Stimulus data attributes
- [x] **2.5** Removed old Webpacker/Node files
- [x] **2.6** App runs locally at http://localhost:3000

## Phase 3: Kamal Setup

- [ ] **3.1** Install Kamal gem
- [ ] **3.2** Create `config/deploy.yml` for Hetzner
- [ ] **3.3** Set up Docker configuration (Dockerfile)
- [ ] **3.4** Configure secrets management (KAMAL_REGISTRY_PASSWORD, etc.)
- [ ] **3.5** Set up GitHub Actions for auto-deploy on push to `main`

## Phase 4: Hetzner Server Setup

- [ ] **4.1** Provision Hetzner VPS (recommend: CX21 or higher)
- [ ] **4.2** Point domain DNS to Hetzner IP
- [ ] **4.3** Install Docker on Hetzner server
- [ ] **4.4** Set up PostgreSQL (container or managed)
- [ ] **4.5** Set up persistent storage volume for Active Storage files
- [ ] **4.6** Configure SSL (Kamal handles via Traefik)

## Phase 5: Data Migration (DO → Local) ✓ COMPLETE

SSH access restored to DO server:

- [x] **5.1** Restored SSH access via DO web console
- [x] **5.2** Exported database via `dokku postgres:export`
- [x] **5.3** Downloaded Active Storage files via rsync (729MB)
- [x] **5.4** Imported database locally with Active Storage migrations
- [x] **5.5** Verified: 210 blogs, 309 attachments, 332 files

## Phase 6: Google OAuth Login

- [ ] **6.1** Create Google Cloud project
- [ ] **6.2** Configure OAuth consent screen
- [ ] **6.3** Create OAuth 2.0 credentials (restrict to your domains)
- [ ] **6.4** Add `omniauth-google-oauth2` gem
- [ ] **6.5** Create User model with email whitelist (you + mum)
- [ ] **6.6** Implement sessions controller
- [ ] **6.7** Protect admin routes with Google auth
- [ ] **6.8** Remove old HTTP Basic auth

## Phase 7: Final Cutover

- [ ] **7.1** Deploy to Hetzner via Kamal
- [ ] **7.2** Run smoke tests on Hetzner
- [ ] **7.3** Update DNS TTL low, then switch
- [ ] **7.4** Monitor for issues
- [ ] **7.5** Decommission Digital Ocean droplet

---

## Quick Wins Available Now

These can be done immediately without infrastructure:

1. Rename master → main
2. Start Webpacker → Propshaft migration
3. Set up Kamal config (can test locally with Docker)

## Configuration

| Setting | Value |
|---------|-------|
| Domain | katescuttings.net |
| Hetzner Region | UK (Falkenstein or Nuremberg) |
| Container Registry | GitHub Container Registry (ghcr.io) |
| Google OAuth Domains | thefoales.net, gfsc.studio |
| Database | PostgreSQL in Docker (via Kamal accessory) |
| Current Setup | Dokku on Digital Ocean (migrating away) |

---

## Progress Summary

| Phase | Status |
|-------|--------|
| 1. Git housekeeping | Complete |
| 2. Rails modernization | Complete |
| 3. Kamal setup | Pending |
| 4. Hetzner server | Pending |
| 5. Data migration | Complete (local) |
| 6. Google OAuth | Pending |
| 7. Final cutover | Pending |

## Next Steps

1. Set up Kamal deployment config
2. Provision Hetzner server
3. Deploy and migrate data to Hetzner
4. Implement Google OAuth
5. Final DNS cutover
