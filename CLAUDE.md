# Kate's Cuttings

A gardening blog for Kate Foale, built with Rails. The site has been running since ~2020 and contains 210+ blog posts with photos from her garden "Charnwood" in Nottinghamshire.

## Project Overview

- **Purpose**: Personal gardening blog with photo galleries
- **Owner**: Kate Foale (kim's mum)
- **Domain**: katescuttings.net
- **Current hosting**: Digital Ocean (Dokku) - migrating to Hetzner (Kamal)

## Tech Stack

- Ruby 3.3.6, Rails 7.1.6
- PostgreSQL database
- Active Storage for images (local disk storage)
- Action Text (Trix) for rich text blog content
- Turbo + Stimulus (Hotwire)
- importmap-rails (no Node.js required)

## Key Features

- Blog posts with publication dates and photo galleries
- Lightbox image viewer (Luminous library via CDN)
- Static pages: About Kate, The Garden, The Book
- Admin area at `/admin` (HTTP Basic auth via ENV vars)
- FriendlyId for SEO-friendly URLs

## Local Development

```bash
bin/rails server           # Start dev server at localhost:3000
bin/rails db:migrate       # Run migrations
```

Requires `.env` file with `USERNAME` and `PASSWORD` for admin access.

## Migration Status

See `MIGRATION_PLAN.md` for full details. Currently:
- ✓ Modernized from Webpacker to importmaps
- ✓ Production data imported locally
- Pending: Kamal deployment, Hetzner migration, Google OAuth

## ClaudeOnRails Configuration

Review the ClaudeOnRails context file at @.claude-on-rails/context.md
