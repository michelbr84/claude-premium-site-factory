# Asset Modes & Replicate Pipeline

Every site runs in exactly one of three asset modes. Choose automatically, or obey the
user if they name one. State the chosen mode in `SITE_BRIEF.md` and the final report.

| Mode | When | What ships |
|------|------|-----------|
| `generate-with-replicate` | `REPLICATE_API_TOKEN` present (in `.env.local` or env) | A **small curated set** (typically 3–5 assets: hero, 1–2 section images, texture, OG image) generated via the script, plus fallbacks kept as safety net — **and at least one short generated video** |
| `prompts-only` | No token, but the user plans to generate later (or asks for prompts) | Deterministic fallbacks in active use + finalized prompts in `SITE_BRIEF.md` + ready-to-run `scripts/generate-assets.mjs` — video comes from the procedural path |
| `no-api` | No token, no stated interest in generation | Deterministic SVG/CSS fallbacks designed as the *final* look (not placeholders) + the same script and prompts left behind quietly — video comes from the procedural path |

In every mode the site must ship complete and premium — fallbacks are a design choice,
not a degradation. `no-api` and `prompts-only` differ only in how prominently the
generation path is documented and reported. **The mandatory video applies in all three
modes** (see `video-direction.md` and the workflow below): only the production method
changes — Replicate with a token, procedural ffmpeg without one.

## Token rules

- Token comes from `REPLICATE_API_TOKEN` in the project's `.env.local` (user-created) or
  the shell environment. Check with a script that reads env — never print the token.
- Never `NEXT_PUBLIC_REPLICATE_API_TOKEN`, never hardcode, never commit, never log.
- All generation happens in local Node scripts (`scripts/generate-assets.mjs`) run at dev
  time — nothing calls Replicate from the browser or at runtime.

## If no token is available (`prompts-only` / `no-api`)

Do not stop. Build deterministic fallbacks (see `visual-direction.md`) and leave behind:
- `scripts/generate-assets.mjs` — ready to run once a token exists
- an asset plan with final prompts in `SITE_BRIEF.md` (or `assets-plan.md`)
- `public/assets/fallbacks/` in active use by the site

Tell the user in the final report how to add the token and run the script later
(prominently in `prompts-only`, as a brief note in `no-api`).

## Asset plan before generating

Write the plan first: which assets, exact prompts, aspect ratios, and where each is used.
Generate only what the site actually uses — a small curated set, no random variation
batches. Prompts must express THIS site's visual thesis (palette, light, mood from
`SITE_BRIEF.md`), not a generic house look. Typical set:

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

## Video-generation workflow (mandatory video)

Every site must ship at least one real video (`video-direction.md` defines what
counts). Work through this ladder and stop at the first success:

1. **Replicate (token present).** Attempt ONE short curated video (4–8s) whose concept
   comes from the visual thesis and the industry's video concepts:
   - Text-to-video or image-to-video (animating the generated hero still keeps the set
     coherent). Pick a current capable model from Replicate's catalog at build time
     (search "video" on replicate.com/explore or use a known-good default such as the
     latest wan/kling/veo-family model available; verify it exists before calling).
     Video models are slower and pricier than image models — one asset, no variation
     batches, poll with a generous timeout.
   - Save to `public/assets/video/` (e.g. `hero-loop.mp4`), re-encode with ffmpeg if
     needed (H.264, `yuv420p`, `+faststart`, target sizes in `video-direction.md`),
     export a poster frame.
   - Extend `scripts/generate-assets.mjs` (or add `scripts/generate-video.mjs`) so the
     user can regenerate; same token rules — read from env, never print, never commit.
2. **Replicate failed or no token → procedural.** Build the video locally with the
   ffmpeg recipes in `video-direction.md` (SVG/frames → video, generative gradients,
   Ken Burns over stills, waveform motion). This is a designed final asset, not a
   stopgap. If Replicate failed, say so in the report and note the fallback used.
3. **Nothing worked** (no token AND no ffmpeg obtainable): ship the site with the
   poster/static composition in the video's place, leave `scripts/generate-video.mjs`
   + prompts ready, and mark `VIDEO REQUIREMENT: FAILED` in the final report with the
   exact missing pieces. Never fake success.

Store videos only under `public/assets/video/` or `public/media/video/`. Posters live
next to their video or under `public/assets/` with the other imagery.

**Active-experience note:** producing the file is half the requirement — the shipped
site must use it as a hero autoplay loop and/or a scroll-driven sequence
(`video-direction.md`). For a scroll-scrub video, also produce the dense-keyframe
re-encode (`-g 1`).

## Optional audio workflow (soundtrack — never blocks the build)

Only when the user wants music or the brand clearly benefits (`audio-direction.md` has
the full UX/consent rules — sound NEVER autoplays):

1. **Token present:** generate ONE short tasteful piece with `minimax/music-2.6` on
   Replicate (fallback `minimax/music-2.5`; verify the slug exists before calling).
   Usually `is_instrumental: true` + a `prompt` derived from the visual thesis
   (mood, tempo/BPM, key, instrumentation). Save under `public/assets/audio/` (or
   `public/media/audio/`), mp3, ≤ ~4MB (trim/re-encode with ffmpeg if needed). Wire it
   through the consent-gated `SoundToggle` — off by default, low volume.
   Music generation is slow (1–3+ min) — poll patiently; failure here never fails the
   site.
2. **No token / generation failed:** write the polished soundtrack prompt into
   `SITE_BRIEF.md`, leave a ready-to-run generation script, and report
   `MUSIC: PROMPT-ONLY` (or `MUSIC: FAILED` with the reason). A procedural ambient
   placeholder ships only if genuinely tasteful.

Same token rules as everything else; audio adds no new env vars.

## Optimization

- Images: convert to WebP/AVIF (sharp), responsive sizes via `next/image`.
- Video: MP4 (H.264) + WebM if feasible, target < 4MB hero, always a poster image,
  `preload="metadata"`, mobile gets the poster or a lighter file. Full spec in
  `video-direction.md`.
- Nothing above ~500KB goes into the page without a stated reason.
