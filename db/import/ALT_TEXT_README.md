# Alt Text Generation for Images

This documents the process for generating alt text descriptions for all garden photos using Claude Code's vision capabilities.

## Progress

- **Total attachments**: 309
- **Generated**: 140 (IDs 1-140)
- **Remaining**: 169

Last updated: 2025-12-29

## Files

- `alt-text.json` - JSON mapping of attachment ID to alt text description
- `ALT_TEXT_README.md` - This file

## How to Generate More Alt Text

Alt text is generated in batches of 10 using Claude Code's vision capabilities (Claude Max plan).

### Process

1. **Get attachment info from production:**
```bash
ssh root@95.217.189.128 'docker exec $(docker ps -q --filter "name=katescuttings-web") bin/rails runner "
Attachment.where(id: START..END).each do |a|
  blob = a.image.blob
  puts \"#{a.id}|#{a.title}|#{blob.signed_id}|#{blob.filename}\"
end
"'
```

2. **Download images to temp directory:**
```bash
cd /tmp/kate-batch && rm -f *.jpg
curl -sL -o ID.jpg "https://katescuttings.net/rails/active_storage/blobs/redirect/SIGNED_ID/FILENAME"
```

3. **View images in Claude Code:**
Use the Read tool to view each image file. Claude Code's multimodal capabilities can analyze the garden photos directly.

4. **Generate descriptions:**
Write concise alt text (under 150 characters) focusing on:
- Main subject (plants, flowers, garden features)
- Botanical names where recognizable
- Key visual elements

5. **Update alt-text.json:**
Add new entries to the JSON file after each batch.

6. **Update this README:**
Update the progress section after each session.

### Why This Approach?

- Uses Claude Max subscription (no API costs)
- Claude Code can view images directly via the Read tool
- Progress is saved after each batch to handle interruptions
- No need for API keys or external dependencies

## Apply to Database

Once all alt text is generated, apply it to the production database:

```bash
bin/rails alt_text:apply
```

Or run on production via SSH:
```bash
ssh root@95.217.189.128 'docker exec $(docker ps -q --filter "name=katescuttings-web") bin/rails alt_text:apply'
```

## Alt Text Guidelines

Descriptions should be:
- Concise (under 150 characters)
- Focus on main subject (plants, flowers, garden features)
- Include botanical names where recognizable (e.g., "Miscanthus sinensis", "Papaver orientale")
- Describe the scene without editorializing
- No quotes or prefix in output
