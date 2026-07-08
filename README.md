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

Then invoke the skill with your brief. It works across industries — each site gets its
own **visual thesis** (palette, type, motion, signature section) derived from the
business, guided by built-in patterns for 10+ industries. Three quick examples:

```
/premium-site-factory:build-premium-site Create a premium website for Lumen Odonto, a
dental clinic in Curitiba. Calm light mode, teal accent. CTA: book via WhatsApp
+55 41 95555 0100. Language: Portuguese. Asset mode: no-api.
```

```
/premium-site-factory:build-premium-site Create a premium website for Atelier Norte, a
boutique architecture studio in Lisbon. Gallery-white, editorial, minimal motion.
CTA: mailto:studio@ateliernorte.example.pt. Asset mode: prompts-only.
```

```
/premium-site-factory:build-premium-site Create a premium website for Ledgerline, a B2B
SaaS that automates month-end close. Light editorial, signal-green accent, outcome-led
copy. CTA: book a demo.
```

The skill will scaffold, define the visual thesis, design, write copy, build every
section, add motion, run typecheck/build/secret-scan plus an **anti-clone QA pass**
(the site must be specific to your business — no recycled styling), start a dev server
in the background, and report the localhost URL plus every placeholder it invented
(documented in the generated `SITE_BRIEF.md`). Full briefs for these and more live in
[`examples/`](./examples).

## What you get in a generated site

- Next.js App Router + TypeScript + Tailwind CSS + GSAP/ScrollTrigger
- Complete single-page site: cinematic hero, manifesto, services, signature visual
  section, story/process, showcase, partners, trust layer, final CTA + footer
- A written visual thesis per site, grown from industry patterns (restaurant,
  dental/medical, law, SaaS, architecture, fitness, semiconductor, local service,
  luxury automotive, real estate) — no two industries look alike
- `SITE_BRIEF.md` (visual thesis + content source of truth + placeholder list),
  `README.md`, `CLAUDE.md`
- `scripts/start-localhost.sh` (background dev server) and `scripts/secret-scan.sh`
- `.env.example` — **no real secrets are ever created or committed**

## Asset modes

Every generated site uses one of three modes (auto-detected, or name one in your brief):

| Mode | When | What you get |
|------|------|--------------|
| `generate-with-replicate` | `REPLICATE_API_TOKEN` available | A small curated set of generated assets (hero, section images, OG image) + fallbacks as safety net |
| `prompts-only` | No token yet, you'll generate later | Designed SVG/CSS fallbacks in use + finalized prompts + a ready-to-run script |
| `no-api` | No token, no generation planned | Deterministic SVG/CSS visuals designed as the final look |

### Using `REPLICATE_API_TOKEN` safely

In the **generated site project** (never in this repository):

```bash
cp .env.example .env.local
# edit .env.local → REPLICATE_API_TOKEN=r8_your_token
npm run assets:generate
```

Safety rules (enforced by the generated project's `secret-scan.sh`):

- `.env.local` is **gitignored** — never commit it, never paste the token into any other file
- The token is read only by local/server-side scripts — it is never referenced under a
  `NEXT_PUBLIC_*` (or `VITE_*`) name, so it can never reach the browser bundle
- Get a token at [replicate.com/account/api-tokens](https://replicate.com/account/api-tokens);
  rotate it there if you ever suspect a leak

Without a token the site still ships complete — fallbacks are designed, not degraded.

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
