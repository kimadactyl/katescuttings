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

## Phase 8: Final Cutover & Cleanup ✓ COMPLETE

- [x] **8.1** Verify all functionality on Hetzner
- [x] **8.2** Set up Cloudflare CDN
- [x] **8.3** Configure trusted proxy IPs for Cloudflare

## Phase 9: Improvements & Maintenance ✓ COMPLETE

- [x] **9.1** Improve metadata and SEO (JSON-LD, Open Graph, article meta)
- [x] **9.2** Add RSS feed with auto-discovery
- [x] **9.3** Set up Renovate for dependency updates (7-day stability)
- [x] **9.4** PostgreSQL 16 - already current
- [x] **9.5** Ruby 3.3.6 - already current
- [x] **9.6** Review security (UFW firewall, fail2ban, bundler-audit)
- [x] **9.7** Set up cronjobs (Docker cleanup)
- [x] **9.8** Add Plausible analytics
- [x] **9.9** Performance improvements (eager loading, caching)
- [x] **9.10** Add database_consistency gem and CI step
- [x] **9.11** Add lightbox captions from image titles

## Future Improvements

- [ ] Auto-generate image descriptions using AI
- [ ] Decommission Digital Ocean droplet (if still running)

---

## Configuration

| Setting | Value |
|---------|-------|
| Domain | katescuttings.net |
| Hetzner IP | 95.217.189.128 |
| CDN | Cloudflare |
| Container Registry | GitHub Container Registry (ghcr.io) |
| Google OAuth Domains | thefoales.net, gfsc.studio |
| Database | PostgreSQL 16 in Docker (via Kamal accessory) |
| Analytics | Plausible |
| Dependency Updates | Renovate (7-day stability) |

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
| 8. Final cutover | ✓ Complete |
| 9. Improvements | ✓ Complete |

## Migration Complete! 🎉

The migration from Digital Ocean/Dokku to Hetzner/Kamal is fully complete. The site is now running on modern infrastructure with:

- Rails 8.0.4 on Ruby 3.3.6
- Kamal 2 deployment with auto-deploy via GitHub Actions
- Cloudflare CDN
- Full SEO optimization (JSON-LD, RSS, Open Graph)
- Plausible analytics
- Automated dependency updates via Renovate
- Database consistency checks in CI
