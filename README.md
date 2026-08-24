# Snippet Library

A searchable, self-hosted snippet library for Modern Workplace / EUC
consulting work — PowerShell (Graph SDK, Intune, Entra ID, Exchange Online,
SharePoint) plus Citrix, Igel, NVIDIA, and general Windows troubleshooting
and deployment scripts.

Static site, no backend, no build step, no API token. Snippets live as
individual Markdown files in this repo and are fetched directly by the
page at runtime.

## Features

- **Live search** with a typewriter-animated placeholder that cycles
  through the tags actually present in the library
- **Tag filtering** — click a tag to narrow results, click again to clear
- **Compact card grid** — each card shows only the title; click to open
  the full snippet (description, tags, prerequisites, code) in a modal
- **One-click copy** for code blocks
- **Light / dark theme toggle**, choice persisted in the browser
- **No backend** — `index.html` fetches everything straight from this
  GitHub repo via `raw.githubusercontent.com`, so the page works from
  anywhere without needing to be redeployed when snippets change

## How it works

`index.html` fetches `snippets/manifest.json` (the list of snippet
filenames), then fetches and parses each listed `.md` file — all via
plain `fetch()` calls to `raw.githubusercontent.com`, which allows
unauthenticated cross-origin requests for public repos. There is no
server-side code and no dependency on this specific hosting location:
the page can be opened locally, hosted on GitHub Pages, or copied
anywhere else, and it will still always show the current content of
this repo.

## Repository structure

```
.
├── index.html            ← the entire app (search, tags, modal, theme)
├── README.md
└── snippets/
    ├── manifest.json     ← list of all snippet filenames
    ├── graph-connect-cert.md
    ├── intune-noncompliant-devices.md
    └── ...
```

## One-time setup

This repo must be **public** — `raw.githubusercontent.com` only allows
token-free access to public repos.

Open `index.html`, locate `GITHUB_CONFIG` near the top of the `<script>`
block, and point it at this repo:

```js
const GITHUB_CONFIG = {
  owner: 'your-github-username',
  repo: 'modern-workplace-snippets',
  branch: 'main'
};
```

Commit and push. That's the only configuration step — everything else
is content.

## Snippet format

Each snippet is one Markdown file: YAML frontmatter, a short description,
and exactly one fenced code block.

```markdown
---
id: unique-id
title: "Short, descriptive title"
language: powershell
tags: ["Graph", "Troubleshooting"]
prerequisites: ["Local admin rights", "Firewall: outbound TCP 443"]
---

One or two sentences describing what the snippet does and when to use it.

\`\`\`powershell
Get-MgUser -UserId "user@contoso.com"
\`\`\`
```

| Field           | Required | Notes                                                             |
|-----------------|----------|--------------------------------------------------------------------|
| `id`            | yes      | Unique, kebab-case, matches the filename (without `.md`)          |
| `title`         | yes      | Shown as the card title and modal heading                         |
| `language`      | no       | Defaults to the fenced code block's language, or `powershell`     |
| `tags`          | yes      | Array of strings; also feeds the search placeholder rotation      |
| `prerequisites` | no       | Array of strings; omit or use `[]` to hide the box entirely       |

## Adding a snippet

1. Create `snippets/<id>.md` following the format above
2. Add the filename to `snippets/manifest.json`
3. Commit and push

```bash
git add snippets/<id>.md snippets/manifest.json
git commit -m "Snippet: <title>"
git push
```

No rebuild, no redeploy — the next page load picks it up automatically.

### Regenerating manifest.json

If keeping the manifest in sync by hand gets tedious:

```bash
python3 -c "
import json, os
files = sorted(f for f in os.listdir('snippets') if f.endswith('.md'))
json.dump(files, open('snippets/manifest.json', 'w'), indent=2)
"
```

## Deployment

Works as-is with any static hosting, including none at all (open the
file locally). For a shareable URL:

**GitHub Pages** — repo settings → Pages → source: branch `main`,
folder `/ (root)` → save. Available at
`https://<owner>.github.io/<repo>/`.

No code changes needed for any hosting choice — `index.html` always
pulls snippet data from this repo via an absolute URL, independent of
where the page itself is served from.

## Local testing

Since snippet data comes from `raw.githubusercontent.com` rather than
relative local paths, `index.html` can usually be opened directly
(double-click, `file://`) once the repo is pushed and public. If a
browser blocks that, fall back to a local server:

```bash
python3 -m http.server 8000
```
Then open `http://localhost:8000`.

## Design notes

- No custom edit UI, no write access from the browser — editing stays
  Git-native (clone, edit, commit, push), which keeps history, diffs,
  and rollback for free and avoids putting any credentials in client-side
  code.
- One file per snippet instead of one large JSON — smaller, readable
  diffs per change, and no merge conflicts when multiple snippets are
  edited in parallel.
