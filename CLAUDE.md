# Kate's Cuttings

A gardening blog for Kate Foale, built with Rails. The site has been running since ~2020 and contains 210+ blog posts with photos from her garden "Charnwood" in Nottinghamshire.

## Project Overview

- **Purpose**: Personal gardening blog with photo galleries
- **Owner**: Kate Foale (kim's mum)
- **Domain**: katescuttings.net
- **Hosting**: Hetzner VPS with Kamal 2
- **CDN**: Cloudflare

## Tech Stack

- Ruby 3.3.6, Rails 8.0.4
- PostgreSQL 16 database
- Active Storage for images (local disk storage)
- Action Text (Trix) for rich text blog content
- Turbo + Stimulus (Hotwire)
- importmap-rails (no Node.js required)
- Kamal 2 deployment to Hetzner

## Key Features

- Blog posts with publication dates and photo galleries
- Lightbox image viewer with captions (Luminous library via CDN)
- Static pages: About Kate, The Garden, The Book
- Admin area at `/admin` (Google OAuth, restricted to family domains)
- FriendlyId for SEO-friendly URLs
- RSS feed at `/blogs.rss`
- JSON-LD structured data on all pages
- Plausible analytics

## Local Development

```bash
bin/rails server           # Start dev server at localhost:3000
bin/rails db:migrate       # Run migrations
bin/rails test             # Run tests
bundle exec database_consistency  # Check DB constraints
```

In development, admin access auto-logs in as the first user (no OAuth needed).

## Deployment

Pushes to `master` branch auto-deploy via GitHub Actions.

```bash
kamal deploy      # Manual deploy
kamal console     # Rails console on production
kamal logs        # Tail production logs
```

## SEO & Metadata

- Open Graph and Twitter Card meta tags on all pages
- JSON-LD structured data (WebSite, Blog, BlogPosting, Person, Place, Book schemas)
- Image titles used for alt text and lightbox captions
- RSS feed with auto-discovery
- Sitemap at `/sitemap.xml`

## ClaudeOnRails Configuration

Review the ClaudeOnRails context file at @.claude-on-rails/context.md
