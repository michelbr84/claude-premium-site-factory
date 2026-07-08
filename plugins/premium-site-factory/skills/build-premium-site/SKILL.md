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

Read `references/replicate-assets.md` only if asset generation comes up, and
`references/deployment-checklist.md` when you reach QA.

If a `frontend-design` skill or plugin is available in the session, apply its guidance on
top of `visual-direction.md`.

## Inputs — infer, don't interrogate

Do not ask questions unless truly blocked. Infer from the folder name, the user's arguments,
and any existing files. Useful inputs: company name, industry, audience, primary CTA,
phone/email/WhatsApp, domain, tone, colors, services, locations, proof points.

Anything missing: invent a tasteful, clearly-fictional placeholder and **document every
placeholder in `SITE_BRIEF.md`** so the user knows exactly what to replace.

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
3. **Design system** — brand tokens (colors, type scale, spacing) in `@theme`, fonts via
   `next/font`, layout primitives (container, section, heading), buttons, nav, footer.
   Follow `references/visual-direction.md`.
4. **Content** — write all copy for every section now, in the site's language. Polished,
   short, confident. No lorem ipsum anywhere.
5. **Assets** — if `REPLICATE_API_TOKEN` exists in `.env.local`, follow
   `references/replicate-assets.md`. Otherwise build deterministic fallbacks (SVG, CSS
   gradients, canvas textures) and write ready-to-run asset prompts/scripts for later.
   Never let missing assets block the site.
6. **Build sections** — all required sections from `references/site-structure.md`, fully
   responsive, working anchors and CTAs.
7. **Motion** — GSAP/ScrollTrigger only after the static layout works. Respect
   `prefers-reduced-motion`, simplify on mobile, never permanently hide content behind an
   animation.
8. **QA** — run typecheck, lint (if configured), and `npm run build`; fix until green. Run
   `bash scripts/secret-scan.sh` from the project root and fix anything it finds. Then walk
   `references/deployment-checklist.md`. When everything passes, make the initial git
   commit so the user gets a clean baseline.
9. **Localhost** — start the dev server without blocking the session:
   `bash scripts/start-localhost.sh` (finds a free port from 3000, binds 127.0.0.1, writes
   `.local/dev.pid` and `.local/dev.log`, waits until the server responds, prints the URL).
   Verify the URL actually returns HTML (`curl -s`) before reporting it.
10. **Final report** — see below.

## Final report

End with a report containing exactly:

- project path and stack
- **localhost URL**, the port, and how to stop the server (`kill $(cat .local/dev.pid)`)
- sections implemented
- assets: generated vs. fallback, and where asset prompts live if deferred
- env/secrets status: what `.env.example` contains, that no secret is tracked, secret-scan result
- validation results: typecheck / lint / build, honestly (if something failed, say so)
- every placeholder the user must replace (mirror of `SITE_BRIEF.md`)
- recommended next steps (real assets, domain, deploy)

## What "one shot" means

One shot = complete first version + assets or fallbacks + green build + running localhost +
honest report. It does not mean skipping QA, faking validation results, or leaving secrets
exposed. Only stop mid-way for destructive actions, payments, logins, external deployments,
or a missing decision that genuinely cannot be defaulted.
