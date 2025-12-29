# KatesCuttings Migration & Upgrade Plan

## Current State

| Component | Current | Notes |
|-----------|---------|-------|
| Ruby | 3.3.6 | Current |
| Rails | 8.0.4 | Upgraded from 7.1.x |
| Database | PostgreSQL 16 | On Hetzner (Docker) |
| Assets | Propshaft + importmaps | Migrated from Webpacker |
| JS Framework | Turbo + Stimulus | Migrated from Turbolinks |
| Image Storage | Active Storage (local disk) | Persistent Docker volume |
| Auth | Google OAuth | Domain-restricted (thefoales.net, gfsc.studio) |
| Deployment | Kamal 2 | Auto-deploy via GitHub Actions |
| Hosting | Hetzner | Migrated from Digital Ocean |

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

## Phase 3: Kamal Setup ✓ COMPLETE

- [x] **3.1** Install Kamal gem
- [x] **3.2** Create `config/deploy.yml` for Hetzner + ghcr.io
- [x] **3.3** Create Dockerfile with multi-stage build
- [x] **3.4** Configure `.kamal/secrets` for environment variables
- [x] **3.5** Set up GitHub Actions for auto-deploy on push to `main`

## Phase 4: Hetzner Server Setup ✓ COMPLETE

- [x] **4.1** Provision Hetzner VPS
- [x] **4.2** Point domain DNS to Hetzner IP (95.217.189.128)
- [x] **4.3** Install Docker on Hetzner server
- [x] **4.4** Set up PostgreSQL (container via Kamal accessory)
- [x] **4.5** Set up persistent storage volume for Active Storage files
- [x] **4.6** Configure SSL (Kamal handles via kamal-proxy)

## Phase 5: Data Migration (DO → Hetzner) ✓ COMPLETE

- [x] **5.1** Restored SSH access via DO web console
- [x] **5.2** Exported database via `dokku postgres:export`
- [x] **5.3** Downloaded Active Storage files via rsync (729MB)
- [x] **5.4** Imported database locally with Active Storage migrations
- [x] **5.5** Verified: 210 blogs, 309 attachments, 332 files
- [x] **5.6** Migrated data to Hetzner production server

## Phase 6: Google OAuth Login ✓ COMPLETE

- [x] **6.1** Create Google Cloud project
- [x] **6.2** Configure OAuth consent screen
- [x] **6.3** Create OAuth 2.0 credentials (restrict to family domains)
- [x] **6.4** Add `omniauth-google-oauth2` gem
- [x] **6.5** Create User model with domain whitelist
- [x] **6.6** Implement sessions controller
- [x] **6.7** Protect admin routes with Google auth
- [x] **6.8** Remove old HTTP Basic auth

## Phase 7: Rails 8 Upgrade ✓ COMPLETE

- [x] **7.1** Update Rails gem to 8.0.4
- [x] **7.2** Fix deprecated configurations
- [x] **7.3** Update CI workflow
- [x] **7.4** Deploy and verify

## Phase 8: Final Cutover & Cleanup

- [ ] **8.1** Verify all functionality on Hetzner
- [ ] **8.2** Decommission Digital Ocean droplet
- [ ] **8.3** Clean up any legacy configuration

## Phase 9: Improvements & Maintenance

- [ ] **9.1** Improve metadata and SEO
- [ ] **9.2** Tidy up rich text plugins and areas
- [ ] **9.3** Set up Dependabot for dependency updates
- [ ] **9.4** Update PostgreSQL version
- [ ] **9.5** Update Ruby version
- [ ] **9.6** Review security
- [ ] **9.7** Set up cronjobs (Docker cleanup, cert renewal)
- [ ] **9.8** Add Plausible analytics
- [ ] **9.9** Explore performance improvements

---

## Configuration

| Setting | Value |
|---------|-------|
| Domain | katescuttings.net |
| Hetzner IP | 95.217.189.128 |
| Container Registry | GitHub Container Registry (ghcr.io) |
| Google OAuth Domains | thefoales.net, gfsc.studio |
| Database | PostgreSQL 16 in Docker (via Kamal accessory) |
| Previous Setup | Dokku on Digital Ocean (decommissioning) |

---

## Progress Summary

| Phase | Status |
|-------|--------|
| 1. Git housekeeping | ✓ Complete |
| 2. Rails modernization | ✓ Complete |
| 3. Kamal setup | ✓ Complete |
| 4. Hetzner server | ✓ Complete |
| 5. Data migration | ✓ Complete |
| 6. Google OAuth | ✓ Complete |
| 7. Rails 8 upgrade | ✓ Complete |
| 8. Final cutover | In Progress |
| 9. Improvements | Pending |

## Next Steps

1. Verify Google OAuth is working in production
2. Decommission Digital Ocean droplet
3. Set up Dependabot
4. Add Plausible analytics
5. Review and improve SEO/metadata
