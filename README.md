# Kate's Cuttings

A gardening blog for Kate Foale, featuring rich text editing with Action Text and image galleries with Active Storage. The site showcases "Charnwood", a cottage garden in Nottinghamshire, UK.

**Live site**: [katescuttings.net](https://katescuttings.net)

## Requirements

- Ruby 3.3.6
- PostgreSQL 16

No Node.js required - uses importmap-rails for JavaScript.

## Development Setup

```bash
bundle install        # Install dependencies
rails db:setup        # Setup database
bin/rails server      # Start server at localhost:3000
```

Admin access (`/admin`) auto-logs in during development.

## Deployment

The site is deployed to Hetzner using [Kamal](https://kamal-deploy.org/) with Cloudflare CDN.

```bash
kamal deploy     # Manual deploy
kamal console    # Rails console on production
kamal logs       # Tail production logs
kamal shell      # SSH into the app container
```

Pushes to the `master` branch automatically deploy via GitHub Actions.

## Architecture

| Component | Technology |
|-----------|------------|
| Hosting | Hetzner VPS |
| CDN | Cloudflare |
| Deployment | Kamal 2 with kamal-proxy |
| Database | PostgreSQL 16 (Docker container) |
| Assets | Propshaft + importmap-rails |
| JavaScript | Hotwire (Turbo + Stimulus) |
| Rich Text | Action Text with Trix editor |
| Images | Active Storage (local disk) |
| Auth | Google OAuth (domain-restricted) |
| Analytics | Plausible |

## Features

- Blog posts with photo galleries and lightbox viewer
- RSS feed (`/blogs.rss`)
- JSON-LD structured data for SEO
- Open Graph and Twitter Card meta tags
- Sitemap (`/sitemap.xml`)
- Static pages: About Kate, The Garden, The Book

## CI/CD

GitHub Actions runs on pull requests:
- Rails tests
- Database consistency checks
- Security audit (bundler-audit)
