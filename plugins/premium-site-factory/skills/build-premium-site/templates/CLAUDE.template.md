# CLAUDE.md — {{COMPANY_NAME}} site

Premium cinematic single-page marketing site. Next.js App Router + TypeScript +
Tailwind v4 (tokens in `src/app/globals.css` under `@theme`) + GSAP/ScrollTrigger.

## Rules

- `SITE_BRIEF.md` is the content source of truth; it lists all placeholders. Update it
  whenever copy or contact data changes.
- Secrets only in `.env.local` (gitignored). `REPLICATE_API_TOKEN` is server/script-side
  only — never expose it under a `NEXT_PUBLIC_*` variable name.
- Keep the visual system: don't add new accent colors or font families; reuse the tokens
  and primitives in `globals.css` and `src/components/ui/`.
- Every animation needs a `prefers-reduced-motion` path and a sane mobile variant.
- Before committing: `npm run build` must pass and `bash scripts/secret-scan.sh` must be clean.

## Commands

- `npm run dev` — dev server (or `bash scripts/start-localhost.sh` for background + PID file)
- `npm run build` — production build (must stay green)
- `npm run assets:generate` — regenerate Replicate assets (needs `REPLICATE_API_TOKEN`)
