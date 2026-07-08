# Claude Premium Site Factory

A [Claude Code](https://claude.com/claude-code) plugin marketplace that installs the
**`build-premium-site`** skill: build a complete premium cinematic marketing website
from an empty folder in one pass — Next.js, Tailwind CSS, GSAP, QA and build
validation, secret scan, and a running localhost preview. Optional
[Replicate](https://replicate.com) asset generation (server/script-side only).

## Install

One command (installs globally for your user):

```bash
claude plugin marketplace add michelbr84/claude-premium-site-factory && claude plugin install premium-site-factory@premium-site-tools
```

Or via the install script:

```bash
curl -fsSL https://raw.githubusercontent.com/michelbr84/claude-premium-site-factory/main/install.sh | bash
```

If Claude Code is already open, run `/reload-plugins` (or restart it).

## Usage

Create an **empty folder** for the new site and start Claude Code inside it:

```bash
mkdir -p ~/Projects/MyCompany-Concept && cd ~/Projects/MyCompany-Concept
claude
```

Then invoke the skill with your brief:

```
/premium-site-factory:build-premium-site Create a premium website for My Company.
Industry: luxury car rental. Goal: institutional presentation. CTA: WhatsApp +1 555 000 0000.
Style: cinematic, dark, gold accents, fully original.
```

The skill will scaffold, design, write copy, build every section, add motion, run
typecheck/build/secret-scan, start a dev server in the background, and report the
localhost URL plus every placeholder it invented (documented in the generated
`SITE_BRIEF.md`). Example briefs live in [`examples/`](./examples).

## What you get in a generated site

- Next.js App Router + TypeScript + Tailwind CSS + GSAP/ScrollTrigger
- Complete single-page site: cinematic hero, manifesto, services, signature visual
  section, story/process, showcase, partners, trust layer, final CTA + footer
- `SITE_BRIEF.md` (content source of truth + placeholder list), `README.md`, `CLAUDE.md`
- `scripts/start-localhost.sh` (background dev server) and `scripts/secret-scan.sh`
- `.env.example` — **no real secrets are ever created or committed**

## Optional: Replicate assets

In the **generated site project** (never in this repository):

```bash
cp .env.example .env.local
# edit .env.local → REPLICATE_API_TOKEN=r8_your_token
npm run assets:generate
```

`.env.local` is gitignored. The token is used only by local scripts — never
`NEXT_PUBLIC_*`, never in the browser bundle. Without a token the site uses
deterministic fallbacks and still ships complete.

## Update

```bash
claude plugin marketplace update premium-site-tools
claude plugin update premium-site-factory@premium-site-tools
```

## Uninstall

```bash
claude plugin uninstall premium-site-factory@premium-site-tools
claude plugin marketplace remove premium-site-tools
```

## Repository layout

```
.claude-plugin/marketplace.json        # marketplace manifest (name: premium-site-tools)
plugins/premium-site-factory/          # the plugin
  .claude-plugin/plugin.json
  skills/build-premium-site/           # the skill: SKILL.md + references/ + templates/ + scripts/
examples/                              # ready-to-paste example briefs
install.sh                             # convenience installer
```

## Develop / validate locally

```bash
git clone https://github.com/michelbr84/claude-premium-site-factory
cd claude-premium-site-factory
claude plugin validate .
claude plugin marketplace add ./
claude plugin install premium-site-factory@premium-site-tools
```

## License

[MIT](./LICENSE)
