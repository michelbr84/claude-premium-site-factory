# Premium Site Factory (plugin)

Claude Code plugin with one skill, **`build-premium-site`**, that builds a complete
premium cinematic marketing website from an empty folder in a single pass:

- Next.js (App Router) + TypeScript + Tailwind CSS + GSAP/ScrollTrigger
- A per-site **visual thesis** grown from built-in industry patterns (restaurant,
  dental/medical, law, SaaS, architecture, fitness, semiconductor, local service,
  luxury automotive, real estate) — no house style, no lookalike sites
- Full landing page: cinematic hero, manifesto, services, signature visual section,
  story/process, showcase, trust layer, final CTA
- **Mandatory ACTIVE video** on every site: hero video that visibly autoplays on load
  and/or a scroll-driven video that advances with scroll — a static video tag doesn't
  pass. Replicate-generated with a token, procedural ffmpeg without; poster +
  muted/playsInline + reduced-motion handled; the report grades
  `HERO AUTOPLAY VIDEO` / `SCROLL-DRIVEN VIDEO` PASS/FAIL honestly
- **Optional consent-gated soundtrack**: never autoplays, off by default, explicit
  "Enable sound"/"Ativar trilha" control, low volume, pause/mute — MiniMax Music
  (`minimax/music-2.6`) via Replicate with a token, or an honest
  `MUSIC: PROMPT-ONLY`/`FAILED` status
- QA: typecheck, build, secret scan, responsive + accessibility checklist, an
  anti-clone pass (industry-appropriate palette, copy voice, CTA, signature section),
  a blocking video QA pass, and a non-blocking music QA pass
- Background localhost dev server with the URL handed to you
- Three asset modes: `no-api` (designed SVG/CSS visuals), `prompts-only` (fallbacks +
  finalized prompts + ready-to-run script), `generate-with-replicate` (small curated
  set; token stays in `.env.local`, server/script-side only) — video ships in all three

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
  references/        # quality bar, site structure, visual direction, industry patterns,
                     # video direction (active experience), audio direction (consent-gated
                     # soundtrack), asset modes, QA checklist (anti-clone + video + music)
  templates/         # env.example, SITE_BRIEF, README, CLAUDE.md templates for generated sites
  scripts/           # start-localhost.sh, secret-scan.sh (copied into generated sites)
```

See the [repository README](../../README.md) for installation.
