# Video Direction

Every generated site MUST ship at least one **real video**: an actual `.mp4`/`.webm`
file on disk, served from the app's public directory, embedded with an HTML `<video>`
element, and visible on the final page. This is a blocking requirement (see the Video QA
pass in `deployment-checklist.md`).

## What counts — and what doesn't

Counts:
- A local video file (MP4 H.264 and/or WebM) under `public/assets/video/` or
  `public/media/video/`, rendered via `<video>` and visible on the page.

Does NOT count:
- CSS animation, animated SVG/SMIL, canvas/WebGL animation, Lottie, or GIFs — unless
  exported/rendered into an actual video file and embedded with `<video>`.
- A `<video>` tag pointing at a missing, empty, or near-empty file.
- A remote/hotlinked video URL (must be local/public-safe).

If, after trying every path below, no real video can be produced (e.g. no token AND no
ffmpeg on the machine), the site still ships — but the final report MUST mark the video
requirement as **FAILED**, state exactly what was missing (tool, token, codec), and
leave behind the script + prompts that will produce the video later. Never claim
success without a playing video.

## Placement — intentional, not decorative

Choose at least one, driven by the visual thesis:

1. **Hero cinematic loop** — full-bleed background, 4–8s seamless loop.
2. **Scroll-driven sequence** — a product/brand video scrubbed or revealed with
   ScrollTrigger (build the plain autoplay version FIRST; add scroll control only after
   it works).
3. **Signature visual video section** — the centerpiece section built around a video.
4. **Atmospheric background layer** — subtle motion behind content (low contrast,
   heavily scrimmed, never fighting the text).

## Reusable component — build once, use everywhere

Create `src/components/ui/BrandVideo.tsx` (client component) and route every video
through it. Requirements:

- Props: `src` (mp4), optional `webmSrc`, `poster` (required), `className`, `priority`.
- Renders `<video>` with `muted`, `loop`, `playsInline`, `autoPlay`, `preload="metadata"`
  (or `"auto"` only for the hero), `poster`, `aria-hidden="true"` for decorative use,
  and `disablePictureInPicture`.
- **React SSR trap:** React does not reliably serialize the `muted` attribute into
  server-rendered HTML — autoplay then fails on some browsers. Set
  `ref={(el) => { if (el) { el.muted = true; el.defaultMuted = true; } }}` (or set both in
  a `useEffect`) in addition to the `muted` prop.
- Reduced motion: with `prefers-reduced-motion: reduce`, don't autoplay — show the
  poster (pause the video and keep it at the poster frame). The page must remain
  complete and readable.
- Performance: pause when off-screen via `IntersectionObserver`; on data-saver
  (`navigator.connection?.saveData`) show the poster only.
- Every video ALWAYS has a poster image (first/best frame exported as WebP/JPEG) so the
  layout is complete before load and under reduced motion.

## Technical spec

- Formats: MP4 (H.264, `yuv420p`, `+faststart`) required; WebM (VP9) optional second
  source. Even dimensions (H.264 requires width/height divisible by 2).
- Duration: 4–8s loop for hero/background; up to ~15s for a signature/scroll piece.
- Size targets: hero ≤ 4MB (aim 1.5–3MB), background layers ≤ 2MB, signature ≤ 8MB.
- Resolution: 1920×1080 max for full-bleed (1280×720 is often enough for a moody,
  blurred, or dark backdrop); crop to the section's actual aspect.
- Loop hygiene: the last frame must flow into the first (crossfade the tail, use a
  palindrome `-filter_complex "[0]reverse[r];[0][r]concat"`, or design a cyclic motion).
- Mobile: same video is fine if ≤ ~3MB; otherwise serve a lighter file or poster-only
  via media queries/JS.

## Procedural video (no token, or Replicate failed)

A designed procedural video is the deterministic fallback — treat it as a final asset,
not a stopgap. Check `ffmpeg -version` first; if ffmpeg is missing, try
`npx --yes @ffmpeg-installer/ffmpeg` / `ffmpeg-static` via a tiny Node script before
declaring failure.

Recipes (adapt palette/geometry to the visual thesis):

1. **Animated SVG/DOM → frames → video** (richest look): render the site's own
   signature SVG animation headlessly (Playwright/Puppeteer screenshot loop at 30fps,
   4–6s), then:
   `ffmpeg -framerate 30 -i frames/%04d.png -c:v libx264 -pix_fmt yuv420p -movflags +faststart out.mp4`
2. **Pure ffmpeg generative gradients** (no browser needed): layered `gradients`
   source + slow hue drift, e.g.
   `ffmpeg -f lavfi -i "gradients=s=1920x1080:speed=0.02:c0=#0A0A0B:c1=#123B36,hue=H=0.4*t" -t 6 -c:v libx264 -pix_fmt yuv420p -movflags +faststart bg.mp4`
3. **Film-grain/atmosphere layer**: `-f lavfi -i "color=c=#0A0A0B:s=1920x1080,noise=alls=12:allf=t"`
   over a gradient, 4s palindrome loop.
4. **Ken Burns over generated/fallback stills**: `zoompan` on the hero image —
   `ffmpeg -loop 1 -i hero.png -vf "zoompan=z='min(zoom+0.0008,1.08)':d=180:s=1920x1080" -t 6 ...`
5. **Waveform/data motion** (SaaS/tech): `-f lavfi -i "aevalsrc=sin(440*2*PI*t):d=6" -filter_complex showwaves`
   tinted to the accent color.

Export the poster from the best frame:
`ffmpeg -i out.mp4 -ss 00:00:01 -frames:v 1 poster.jpg`

Keep whichever generation script produced the video in `scripts/` (e.g.
`scripts/generate-video.mjs` or documented ffmpeg commands in `SITE_BRIEF.md`) so the
user can regenerate or upgrade it later.

## Per-industry video concepts

Grow the concept from the visual thesis; these are starting points, same rules as
`industry-patterns.md` (don't recycle across industries):

- **AI / SaaS / tech product (e.g. an AI agent platform):** command network coming
  alive (nodes lighting along routed paths); a permission graph assembling; agent
  orchestration flow (task fanning out to tools and returning); document/email/calendar
  streams merging into one timeline; a voice waveform that resolves into structured
  intelligence; a secure tool-routing mesh with pulses traveling authorized edges.
- **Restaurant / fine dining:** ember and smoke drifting; slow pour or plating macro
  motion; steam rising through a light beam; the fire cycle as ambient loop.
- **Architecture / interiors:** light moving across a wall through a day; plan lines
  drawing then dissolving into space; dust motes in a sunbeam; slow dolly through a
  volume (procedural: parallax layers of plan geometry).
- **Dental / medical:** calm light-field drift (soft caustics on bone white); the
  patient-journey line flowing through its four steps; breathing-pace gradient pulse —
  reassurance, never clinical gore.
- **Law firm:** ink spreading in water (slowed, dignified); typographic ledger lines
  assembling a document structure; slow depth-of-field pan over paper texture.
- **Real estate:** golden-hour light sweeping a facade; window-light grid of a building
  waking at dusk; floor-plan-to-skyline morph.
- **Fitness / wellness:** chalk dust in air (energetic) or tide/breath rhythm loop
  (restorative); a pulse/effort line building through interval phases.
- **Semiconductor / electronics:** signal pulses routing through PCB traces; a die
  shot with light sweeping the layers; waveform sweeping across a measurement grid.
- **Local service:** the service day as time-lapse motion; tool-and-material textures
  in honest daylight; a route pulse only if service area is genuinely the product.
- **Luxury automotive:** paint-depth light sweep; asphalt at dusk with headlight
  trails; slow orbital fragment of a body line.

## Integration order

1. Produce the video file (Replicate → procedural → report failure honestly).
2. Export the poster; wire both through `BrandVideo`.
3. Verify autoplay works in the served page (muted + playsInline present in DOM).
4. Only then add scroll-driven behavior (ScrollTrigger scrub/pin) if the design calls
   for it, with the plain autoplay version as the reduced-motion/mobile path.
