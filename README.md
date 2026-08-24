# Snippet Library

A static snippet library. No backend, no build step, no token/PAT required.

Each snippet is its own Markdown file under `/snippets` in a **public**
GitHub repo. `index.html` fetches `manifest.json` and every listed `.md`
file directly from `raw.githubusercontent.com` at runtime — no server-side
code, no API token, no CORS issues (raw.githubusercontent.com allows
unauthenticated cross-origin requests for public repos).

This decouples the app from its data: `index.html` can be hosted anywhere
(GitHub Pages, any static host, or just opened locally) and will always
show the current content of the repo without needing to be redeployed.

## Structure

```
snippet-lib/
├── index.html          ← display, search, tag filter, fetches from GitHub
├── snippets/
│   ├── manifest.json    ← list of all snippet files
│   ├── graph-connect-cert.md
│   ├── intune-noncompliant-devices.md
│   └── ...
```

## One-time setup

Open `index.html`, find `GITHUB_CONFIG` near the top of the `<script>`
block, and set it to your repo:

```js
const GITHUB_CONFIG = {
  owner: 'your-github-username',
  repo: 'snippet-lib',
  branch: 'main'
};
```

Requires the repo to be **public**. For a private repo, this direct
`raw.githubusercontent.com` approach doesn't work without a read-only
token — ask if you want that variant instead.

## Snippet format

Each file: YAML frontmatter + description + one code block.

```markdown
---
id: unique-id
title: "Short title"
language: powershell
tags: ["Graph", "Troubleshooting"]
prerequisites: ["Local admin rights", "Firewall: outbound TCP 443"]
---

One or two sentences describing what the snippet does.

\`\`\`powershell
Get-MgUser -UserId "user@contoso.com"
\`\`\`
```

`prerequisites` is optional — use an empty array (`[]`) or omit the field
entirely, and no prerequisites box will show on the card.

## Adding a new snippet

1. Create a new `.md` file under `/snippets` (format as above)
2. Add the filename to `snippets/manifest.json` (alphabetical order optional)
3. Commit + push

```bash
git add snippets/my-new-snippet.md snippets/manifest.json
git commit -m "Snippet: <title>"
git push
```

The next time anyone opens `index.html`, it fetches the updated
`manifest.json` and picks up the new file — no rebuild, no redeploy.

## Auto-regenerating manifest.json

Optional, if maintaining it manually gets tedious — a one-liner that
rebuilds `manifest.json` from the actual directory contents:

```bash
python3 -c "
import json, os
files = sorted(f for f in os.listdir('snippets') if f.endswith('.md'))
json.dump(files, open('snippets/manifest.json', 'w'), indent=2)
"
```

## Repo setup (GitHub)

```bash
git init
git add .
git commit -m "init"
git remote add origin <repo-url>
git branch -M main
git push -u origin main
```

Repo must be **public** for `index.html` to load snippets without a token
(Settings → General → Danger Zone → Change visibility, if it isn't already).

## Deployment (GitHub Pages)

Repo settings → Pages → Source: branch `main`, folder `/ (root)` → Save.
URL: `https://<owner>.github.io/<repo>/`

No code changes needed — `index.html` fetches snippets via an absolute
`raw.githubusercontent.com` URL, so it works the same whether opened
locally, via Pages, or from any other static host.

## Testing locally

Since data now comes from `raw.githubusercontent.com` rather than local
files, `index.html` can usually be opened directly (double-click, `file://`)
without a local server — as long as the repo is pushed and public. If your
browser still blocks it, fall back to:

```bash
python3 -m http.server 8000
```
Then open `http://localhost:8000`.
