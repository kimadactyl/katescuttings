# Kate's Cuttings

A gardening blog for Kate Foale, built with Rails. The site has been running since ~2020 and contains 210+ blog posts with photos from her garden "Charnwood" in Nottinghamshire.

## Project Overview

- **Purpose**: Personal gardening blog with photo galleries
- **Owner**: Kate Foale (kim's mum)
- **Domain**: katescuttings.net
- **Current hosting**: Hetzner (Kamal)

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
- Lightbox image viewer (Luminous library via CDN)
- Static pages: About Kate, The Garden, The Book
- Admin area at `/admin` (Google OAuth, restricted to family domains)
- FriendlyId for SEO-friendly URLs

## Local Development

```bash
bin/rails server           # Start dev server at localhost:3000
bin/rails db:migrate       # Run migrations
```

Requires Google OAuth credentials for admin access (see MIGRATION_PLAN.md).

## Migration Status

See `MIGRATION_PLAN.md` for full details. Currently:
- ✓ Modernized from Webpacker to importmaps
- ✓ Upgraded to Rails 8
- ✓ Migrated to Hetzner with Kamal
- ✓ Implemented Google OAuth for admin
- Pending: Final cleanup and improvements

## ClaudeOnRails Configuration

Review the ClaudeOnRails context file at @.claude-on-rails/context.md
