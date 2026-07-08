# Replicate Asset Pipeline

Only relevant when the user wants generated assets. Never required — the site must work
with fallbacks regardless.

## Token rules

- Token comes from `REPLICATE_API_TOKEN` in the project's `.env.local` (user-created) or
  the shell environment. Check with a script that reads env — never print the token.
- Never `NEXT_PUBLIC_REPLICATE_API_TOKEN`, never hardcode, never commit, never log.
- All generation happens in local Node scripts (`scripts/generate-assets.mjs`) run at dev
  time — nothing calls Replicate from the browser or at runtime.

## If no token is available

Do not stop. Build deterministic fallbacks (see `visual-direction.md`) and leave behind:
- `scripts/generate-assets.mjs` — ready to run once a token exists
- an asset plan with final prompts in `SITE_BRIEF.md` (or `assets-plan.md`)
- `public/assets/fallbacks/` in active use by the site

Tell the user in the final report how to add the token and run the script later.

## Asset plan before generating

Write the plan first: which assets, exact prompts, aspect ratios, and where each is used.
Generate only what the site actually uses — no random variation batches. Typical set:

- hero backdrop (image, or video via an image-to-video model if requested) — 16:9 desktop
- 1–3 section images sharing the same visual world — match section layout
- abstract texture/background for the signature or manifesto section
- social preview (OG) image — 1200×630
- favicon/brand mark concept only if requested

## Prompt discipline

Include in every prompt: subject, environment, lighting, camera/lens feel, palette
matching the brand tokens, and negatives (no text, no watermarks, no logos, no license
plates, no people's faces unless intended). Keep one consistent style phrase across all
prompts so the set feels like one shoot.

## Script conventions

- `scripts/generate-assets.mjs` uses the official `replicate` npm package, reads the token
  from env, and is invoked via package script `assets:generate`. `dotenv` or manual
  parsing of `.env.local` for local runs.
- Save originals to `public/assets/generated/`, keep fallbacks in
  `public/assets/fallbacks/`. Site code prefers generated but must render correctly with
  fallbacks alone.
- Choose current, capable models from Replicate's catalog at build time (search or use
  known-good defaults, e.g. the latest FLUX family for images); handle failures per-asset
  so one failed generation never kills the run.

## Optimization

- Images: convert to WebP/AVIF (sharp), responsive sizes via `next/image`.
- Video: MP4 (H.264) + WebM if feasible, target < 4MB hero, always a poster image,
  `preload="metadata"`, mobile gets the poster or a lighter file.
- Nothing above ~500KB goes into the page without a stated reason.
