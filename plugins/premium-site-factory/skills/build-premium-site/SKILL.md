---
name: build-premium-site
description: Build a complete premium cinematic company website from an empty folder using Next.js, Tailwind CSS, and GSAP — full landing page, QA and build validation, secret scan, and a running localhost preview, with an optional Replicate asset pipeline. Use when the user asks for a full premium/Awwwards-style marketing or institutional site for a business.
argument-hint: "[company name, industry, style, CTA, domain, contact info]"
disable-model-invocation: true
---

# Build Premium Site

Build a **complete, working, premium cinematic website in one execution pass**, then start a
localhost dev server and hand the user the URL. Do not stop after planning. Do not deliver a
mockup, a partial page, or a plan — deliver a running site.

The quality reference is a premium agency concept site (cinematic hero, brand manifesto,
editorial sections, scroll-driven motion). Treat any site the user names as a **quality
reference only**: never copy its text, branding, images, layout, domain, or contact data
unless the user explicitly owns it and asks for that.

Before writing any code, read these files from this skill's directory:

- `references/quality-bar.md` — acceptance criteria the result must meet
- `references/site-structure.md` — the required sections and what each must contain
- `references/visual-direction.md` — design system guidance (read before styling)
- `references/industry-patterns.md` — per-industry direction; find the closest pattern
  to this business before forming the visual thesis

Read `references/replicate-assets.md` when you reach the assets step (it defines the
three asset modes), and `references/deployment-checklist.md` when you reach QA.

If a `frontend-design` skill or plugin is available in the session, apply its guidance on
top of `visual-direction.md`.

## Inputs — infer, don't interrogate

Do not ask questions unless truly blocked. Infer from the folder name, the user's arguments,
and any existing files. Useful inputs: company name, industry, audience, primary CTA,
phone/email/WhatsApp, domain, tone, colors, services, locations, proof points.

Anything missing: invent a tasteful, clearly-fictional placeholder and **document every
placeholder in `SITE_BRIEF.md`** so the user knows exactly what to replace.

## Visual thesis — mandatory, before any styling

Every site starts with a **visual thesis**: 3–5 written lines, derived from THIS business
and the matching pattern in `references/industry-patterns.md`, stating — the emotional
premise (what a visitor should feel), background world + palette temperature, type
personality, motion character, and the signature-section concept. Record it in
`SITE_BRIEF.md`. Every subsequent design decision must trace back to it.

**No inherited defaults.** The factory has no house style. Unless the user asks for them
or the business genuinely calls for them, do NOT default to: dark backgrounds with
gold/champagne accents; automotive imagery or metaphors (fleet, horsepower, showroom,
"concierge" language); route/delivery map sections; or any prior generated site's palette,
section metaphors, or copy patterns. A dental clinic, a law firm, and a SaaS product must
produce sites that could never be mistaken for each other or for a car-rental site.
Dark + metallic accent is reserved for businesses where it earns its place (see the
luxury-automotive pattern).

## Hard rules

- Never commit or create secrets in tracked files. Real tokens live only in `.env.local`.
- Use `REPLICATE_API_TOKEN`. Never `NEXT_PUBLIC_REPLICATE_API_TOKEN` (Next.js ships
  `NEXT_PUBLIC_*` to the browser). If on Vite, never put secrets in `VITE_*`.
- No fabricated legal claims (licenses, insurance, certifications, review counts) — use
  clearly-marked placeholders and list them in `SITE_BRIEF.md`.
- No copied assets, no visible third-party brand logos in generated imagery, no fake
  readable license plates or documents.
- If the target folder is not empty, list what's there and work around it; never overwrite
  existing user work without asking.

## Default stack

Next.js (latest stable, App Router) + React + TypeScript + Tailwind CSS + GSAP with
ScrollTrigger (`gsap` + `@gsap/react`, use the `useGSAP` hook) + Lenis for smooth scroll
when it helps. Three.js/R3F only if it clearly adds value and stays performant. Replicate
only via server-side or local scripts. If a simpler stack fits the request better, say why
in one line and proceed.

Note: current `create-next-app` ships Tailwind v4 (CSS-first config — design tokens go in
`globals.css` under `@theme`, there is no `tailwind.config.js` by default). Don't fight it.

## Workflow

Work in this order. Don't reorder motion before layout, or QA before content.

1. **Preflight** — `pwd`, list files, check for a git repo, detect package manager from any
   lockfile (default to npm on fresh folders). Confirm the folder is empty or safe.
2. **Scaffold** — non-interactive `create-next-app` in place, e.g.:
   `npx create-next-app@latest . --ts --tailwind --eslint --app --src-dir --import-alias "@/*" --use-npm --yes`
   (verify flags with `--help` if the version differs; if files conflict, move them aside,
   scaffold, restore). Known trap: `create-next-app` rejects folder names with capital
   letters (npm naming rules) — scaffold in a lowercase temp dir, move the contents into
   the target, and set the package.json `name` to a lowercased slug. Init git with branch
   `main` if no repo exists. Then create from this skill's `templates/`:
   - `.env.example` (from `templates/env.example`) — never create `.env.local` yourself
   - `SITE_BRIEF.md` (from `templates/SITE_BRIEF.md`, filled in)
   - `README.md` (from `templates/README.template.md`, filled in)
   - `CLAUDE.md` (from `templates/CLAUDE.template.md`, filled in)
   - `scripts/start-localhost.sh` and `scripts/secret-scan.sh` (copy from this skill's
     `scripts/`, keep executable)
   Ensure `.gitignore` covers `.env*` (allowing `.env.example`), `.local/`, `.next/`.
3. **Visual thesis** — write it (see the mandatory section above) into `SITE_BRIEF.md`,
   naming which industry pattern you started from and what you changed for this brand.
4. **Design system** — brand tokens (colors, type scale, spacing) in `@theme`, fonts via
   `next/font`, layout primitives (container, section, heading), buttons, nav, footer.
   Follow `references/visual-direction.md`, expressing the thesis — not a house style.
5. **Content** — write all copy for every section now, in the site's language, in the
   voice the industry pattern prescribes. Polished, short, confident. No lorem ipsum.
6. **Assets** — pick the asset mode per `references/replicate-assets.md`:
   `generate-with-replicate` if `REPLICATE_API_TOKEN` is available (small curated set),
   `prompts-only` if the user wants prompts but has no token yet, `no-api` otherwise
   (deterministic SVG/CSS fallbacks + prompts and a ready-to-run script left behind).
   The user can force a mode by naming it. Never let missing assets block the site.
7. **Build sections** — all required sections from `references/site-structure.md`, fully
   responsive, working anchors and CTAs.
8. **Motion** — GSAP/ScrollTrigger only after the static layout works. Respect
   `prefers-reduced-motion`, simplify on mobile, never permanently hide content behind an
   animation.
9. **QA** — run typecheck, lint (if configured), and `npm run build`; fix until green. Run
   `bash scripts/secret-scan.sh` from the project root and fix anything it finds. Then walk
   `references/deployment-checklist.md`, including its **anti-clone pass** — if the site
   fails that pass, fix the design before reporting; do not ship a lookalike. When
   everything passes, make the initial git commit so the user gets a clean baseline.
10. **Localhost** — start the dev server without blocking the session:
    `bash scripts/start-localhost.sh` (finds a free port from 3000, binds 127.0.0.1, writes
    `.local/dev.pid` and `.local/dev.log`, waits until the server responds, prints the URL).
    Verify the URL actually returns HTML (`curl -s`) before reporting it.
11. **Final report** — see below.

## Final report

End with a report containing exactly:

- project path and stack
- **localhost URL**, the port, and how to stop the server (`kill $(cat .local/dev.pid)`)
- the visual thesis (one line) and which industry pattern it grew from
- sections implemented
- asset mode used (`no-api` / `prompts-only` / `generate-with-replicate`) and what exists
  where; where asset prompts live if deferred
- anti-clone pass result (what makes this site specific to this business)
- env/secrets status: what `.env.example` contains, that no secret is tracked, secret-scan result
- validation results: typecheck / lint / build, honestly (if something failed, say so)
- every placeholder the user must replace (mirror of `SITE_BRIEF.md`)
- recommended next steps (real assets, domain, deploy)

## What "one shot" means

One shot = complete first version + assets or fallbacks + green build + running localhost +
honest report. It does not mean skipping QA, faking validation results, or leaving secrets
exposed. Only stop mid-way for destructive actions, payments, logins, external deployments,
or a missing decision that genuinely cannot be defaulted.
