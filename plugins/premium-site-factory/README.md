# Premium Site Factory (plugin)

Claude Code plugin with one skill, **`build-premium-site`**, that builds a complete
premium cinematic marketing website from an empty folder in a single pass:

- Next.js (App Router) + TypeScript + Tailwind CSS + GSAP/ScrollTrigger
- Full landing page: cinematic hero, manifesto, services, signature visual section,
  story/process, showcase, trust layer, final CTA
- QA: typecheck, build, secret scan, responsive + accessibility checklist
- Background localhost dev server with the URL handed to you
- Optional Replicate asset pipeline (server/script-side only, token stays in `.env.local`)

## Usage

From an **empty folder** for the new site:

```bash
mkdir -p ~/Projects/MyCompany-Concept && cd ~/Projects/MyCompany-Concept
claude
```

Inside Claude Code:

```
/premium-site-factory:build-premium-site Create a premium website for My Company.
Industry: luxury service. CTA: WhatsApp +1 555 000 0000. Style: cinematic, dark, elegant.
```

The skill infers what it can, invents clearly-documented placeholders for the rest
(listed in the generated `SITE_BRIEF.md`), builds the site, validates it, and starts it
on localhost.

## Layout

```
skills/build-premium-site/
  SKILL.md           # the skill entrypoint and workflow
  references/        # quality bar, site structure, visual direction, assets, QA checklist
  templates/         # env.example, SITE_BRIEF, README, CLAUDE.md templates for generated sites
  scripts/           # start-localhost.sh, secret-scan.sh (copied into generated sites)
```

See the [repository README](../../README.md) for installation.
