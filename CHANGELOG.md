# Changelog

## 1.2.0 — 2026-07-08

Mandatory real-video release. Every generated site now ships at least one actual video
file — cinematic motion is part of the premium bar, not an option.

### Added
- `references/video-direction.md`: what counts as a real video (an `.mp4`/`.webm` on
  disk embedded via `<video>` — CSS/SVG/canvas/Lottie/GIF do NOT count unless rendered
  to video), the four intentional placements (hero loop, scroll-driven sequence,
  signature video section, atmospheric layer), a reusable `BrandVideo` component spec
  (poster required, muted + playsInline + the React SSR muted-attribute workaround,
  reduced-motion shows the poster, IntersectionObserver pause, data-saver handling),
  technical specs (H.264 `yuv420p` `+faststart`, 4–8s loops, hero ≤ 4MB), procedural
  ffmpeg recipes (SVG/frames → video, generative gradients, grain layers, Ken Burns,
  waveform motion), and per-industry video concepts — including AI/SaaS concepts
  (command network, permission graph, agent orchestration, document/email/calendar
  flow, voice-waveform intelligence, secure tool-routing mesh).
- **Blocking video QA pass** in `references/deployment-checklist.md`: `<video>` present
  in the served page, referenced file exists and is a real video (not an empty
  placeholder), page reachable, autoplay videos muted + playsInline, poster wired,
  size within targets, secret scan still green after video work.
- Video block in the `SITE_BRIEF.md` template (status, concept, files, placement,
  production method, poster, regeneration instructions) and video guidance in the
  generated `README`/`CLAUDE.md` templates.

### Changed
- `SKILL.md`: mandatory-video section; the assets step now produces the video in every
  asset mode (Replicate with a token → procedural ffmpeg without → honest
  `VIDEO REQUIREMENT: FAILED` in the report if neither is possible); the final report
  now includes video path, placement, file size, poster status, and
  autoplay/loop/muted/playsInline confirmation.
- `references/replicate-assets.md`: dedicated video-generation workflow (curated single
  short video via a current Replicate video model, re-encode + poster export, stored
  under `public/assets/video/` or `public/media/video/`, regeneration script left
  behind; failure falls back to the procedural path and is reported clearly).
- `references/quality-bar.md` and `references/site-structure.md`: real video is part of
  the acceptance criteria and page structure.
- READMEs and example briefs mention the mandatory video and per-brief video ideas.

## 1.1.0 — 2026-07-07

De-bias and industry robustness release. Sites are now designed from the business
outward, not from a house style.

### Added
- `references/industry-patterns.md`: visual/copy/CTA/signature-section guidance for 10
  industries — restaurant, dental/medical, law firm, SaaS, architecture/interior design,
  fitness/wellness, semiconductor/electronics, local service, luxury automotive, real
  estate — each deliberately distinct in palette, type, motion, and signature concept.
- Mandatory **visual thesis** step: every site starts with 3–5 written lines (emotional
  premise, world/palette, type personality, motion character, signature concept) recorded
  in `SITE_BRIEF.md`; all design decisions must trace back to it.
- **Anti-clone QA pass** (blocking) in `references/deployment-checklist.md`: palette
  test, metaphor test, swap test, structure test, industry-appropriate copy voice and
  CTA checks — run before the final report.
- **Asset modes**: `no-api` (deterministic SVG/CSS visuals designed as the final look),
  `prompts-only` (fallbacks + finalized prompts + ready-to-run script), and
  `generate-with-replicate` (small curated set when `REPLICATE_API_TOKEN` exists).
  Mode is auto-detected or user-forced, and reported in `SITE_BRIEF.md`.
- Three non-automotive example briefs: dental clinic, architecture studio, SaaS product.
- README: multi-industry usage examples, asset-mode table, and a safe-usage guide for
  `.env.local` + `REPLICATE_API_TOKEN`.

### Changed
- `SKILL.md`: explicit ban on inherited defaults — no dark/gold palettes, automotive
  metaphors, route/delivery maps, or concierge language unless the business earns them.
- `references/site-structure.md`: signature section must grow from the industry pattern;
  maps only when geography is genuinely the product.
- `templates/SITE_BRIEF.md`: visual-thesis block (pattern used, adaptations, motion
  character, signature justification) and asset-mode field.
- Final report now includes the visual thesis, asset mode, and anti-clone result.

## 1.0.0 — 2026-07-07

Initial release: `premium-site-tools` marketplace with the `premium-site-factory`
plugin and its `build-premium-site` skill — complete premium cinematic sites from empty
folders (Next.js + Tailwind + GSAP), QA/build validation, secret scan, background
localhost preview, optional Replicate assets. E2E-tested headless on a fictional brief.
