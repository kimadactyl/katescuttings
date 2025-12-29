# Kate's Cuttings

A gardening blog built with Ruby on Rails, featuring rich text editing with Action Text and image management with Active Storage.

## Requirements

- Ruby 3.3.6
- PostgreSQL
- Node.js (for asset compilation)

## Development Setup

```bash
# Install dependencies
bundle install

# Setup database
rails db:setup

# Start the server
bin/dev
```

## Deployment

The site is deployed to Hetzner using [Kamal](https://kamal-deploy.org/).

### Deploy manually

```bash
kamal deploy
```

### Auto-deploy

Pushes to the `main` branch automatically deploy via GitHub Actions.

### Useful Kamal commands

```bash
kamal console    # Rails console on production
kamal logs       # Tail production logs
kamal shell      # SSH into the app container
```

## Architecture

- **Hosting**: Hetzner (previously Digital Ocean)
- **Deployment**: Kamal 2 with kamal-proxy
- **Database**: PostgreSQL 16
- **Assets**: Propshaft + importmap-rails
- **JavaScript**: Hotwire (Turbo + Stimulus)
- **Rich Text**: Action Text with Trix editor
- **Images**: Active Storage with local disk storage
