# Kate's Cuttings

A gardening blog for Kate Foale, featuring rich text editing with Action Text and image galleries with Active Storage. The site showcases "Charnwood", a cottage garden in Nottinghamshire, UK.

**Live site**: [katescuttings.net](https://katescuttings.net)

## Requirements

- Ruby 3.4.8
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

Pushes to the `main` branch automatically deploy via GitHub Actions.

## Architecture

| Component  | Technology                       |
| ---------- | -------------------------------- |
| Hosting    | Hetzner VPS                      |
| CDN        | Cloudflare                       |
| Deployment | Kamal 2 with kamal-proxy         |
| Database   | PostgreSQL 16 (Docker container) |
| Assets     | Propshaft + importmap-rails      |
| JavaScript | Hotwire (Turbo + Stimulus)       |
| Rich Text  | Action Text with Trix editor + paste cleanup |
| Images     | Active Storage (local disk)      |
| Auth       | Google OAuth (domain-restricted) |
| Analytics  | Plausible                        |

## Features

- Blog posts with photo galleries and lightbox viewer
- RSS feed (`/blogs.rss`)
- JSON-LD structured data for SEO
- Open Graph and Twitter Card meta tags
- Sitemap (`/sitemap.xml`)
- Static pages: About Kate, The Garden, The Book

## Accessibility

The site follows WCAG 2.1 AA guidelines with automated testing via axe-core:

- Skip-to-main-content link for keyboard users
- Visible focus indicators on all interactive elements
- ARIA labels on navigation and icon buttons
- Semantic HTML5 landmarks (header, nav, main, footer)
- Proper heading hierarchy
- Alt text on all images

## Paste Cleanup

The Trix editor includes automatic cleanup for content pasted from Microsoft Word. When Word HTML is detected, it strips:

- Microsoft-specific classes (`MsoNormal`) and styles (`mso-*`)
- Office namespace tags (`<o:p>`, `<w:*>`)
- Conditional comments (`<!--[if gte mso 9]>`)
- Empty wrapper elements

## Testing

```bash
bin/rails test                    # Run unit/integration tests
bin/rails test:system             # Run accessibility tests (axe-core)
```

JavaScript tests run in the browser:
- Open `test/javascript/word_html_cleaner_test.html` in a browser

## CI/CD

GitHub Actions runs on pull requests:

- Rails tests
- Database consistency checks
- Security audit (bundler-audit)
