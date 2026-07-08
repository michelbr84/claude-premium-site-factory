# Video Direction

Every generated site MUST ship an **active cinematic video experience** — a real video
that visibly PLAYS, not merely exists. This is a blocking requirement (see the Video QA
pass in `deployment-checklist.md`) with two qualifying modes; ship at least one:

- **HERO AUTOPLAY VIDEO** — a hero video that visibly starts playing on page load,
  without any user scroll or interaction (muted, looped, playsInline, poster).
- **SCROLL-DRIVEN VIDEO** — a video whose playback visibly advances with scroll
  progress (ScrollTrigger scrub or a robust scroll→`currentTime` controller).

A static or paused `<video>` element sitting on the page satisfies NOTHING. The final
report must grade both modes explicitly (`HERO AUTOPLAY VIDEO: PASS/FAIL`,
`SCROLL-DRIVEN VIDEO: PASS/FAIL`) and say which one carries the requirement.

The base rule from v1.2 still applies: the video is an actual `.mp4`/`.webm` file on
disk, served from the app's public directory, embedded with an HTML `<video>` element,
and visible on the final page.

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

Choose at least one QUALIFYING placement (1 or 2), driven by the visual thesis:

1. **Hero cinematic loop** (qualifies as HERO AUTOPLAY) — full-bleed background, 4–8s
   seamless loop, visibly playing the moment the page loads.
2. **Scroll-driven sequence** (qualifies as SCROLL-DRIVEN) — a product/brand video
   scrubbed or revealed with ScrollTrigger (build the plain autoplay version FIRST; add
   scroll control only after it works).
3. **Signature visual video section** — the centerpiece section built around a video.
   Qualifies only if it also autoplays in view (hero-style) or scrubs with scroll.
4. **Atmospheric background layer** — subtle motion behind content (low contrast,
   heavily scrimmed, never fighting the text). Qualifies as autoplay if it visibly
   plays on load in the first viewport; a below-the-fold ambience layer alone does not
   carry the requirement.

## Implementation patterns for the two qualifying modes

### Hero autoplay (mode A)

The `BrandVideo` component below already covers it. The traps that break "visibly
plays on load":

- The React SSR `muted` trap (see component spec) — without the ref/effect fix, some
  browsers refuse autoplay because the attribute never reaches the DOM.
- `preload="metadata"` + slow first paint: for the hero specifically use
  `preload="auto"` and keep the file small (≤ 4MB) so playback starts immediately.
- Low Power Mode / data-saver / reduced-motion legitimately block autoplay — the
  poster must make the hero look complete in those cases (that is the designed
  fallback, not a failure).
- Verify in the running page, not by reading your own JSX: the element must report
  `paused === false` shortly after load in a normal browser context.

### Scroll-driven (mode B)

Two sound approaches; pick one:

1. **GSAP ScrollTrigger scrub** — pin the section, map scroll progress to
   `video.currentTime`:

   ```ts
   // client component; video must be muted+playsInline, preload="auto"
   useGSAP(() => {
     const video = videoRef.current!;
     const st = ScrollTrigger.create({
       trigger: sectionRef.current, start: 'top top', end: '+=200%',
       pin: true, scrub: 0.5,
       onUpdate: (self) => {
         if (video.duration) video.currentTime = self.progress * video.duration;
       },
     });
     return () => st.kill();
   }, []);
   ```

2. **rAF scroll-progress controller** (no pin, robust and dependency-light): on scroll,
   compute the section's progress through the viewport, lerp a target time, and write
   `currentTime` inside a `requestAnimationFrame` loop (never directly in the scroll
   handler — thrashing `currentTime` on every scroll event stutters).

Scrubbing requirements (both approaches):

- **Re-encode for scrubbing**: seeking every frame needs dense keyframes —
  `ffmpeg -i in.mp4 -c:v libx264 -pix_fmt yuv420p -g 1 -movflags +faststart scrub.mp4`
  (`-g 1` = every frame a keyframe; file grows, so keep scrub videos short/small, e.g.
  ≤ 10s at 720–1080p). Without this, `currentTime` seeks snap to sparse keyframes and
  the "scrub" visibly stutters or jumps.
- The video element is muted + playsInline with poster, `preload="auto"`.
- Reduced motion: no pinned scrubbing — show the video as a plain paused poster/frame
  or a gentle autoplay if appropriate; the content must remain fully readable.
- Mobile: test that touch scroll drives it; if the pinned scene fights mobile UX,
  serve the autoplay loop instead on small screens (mode A then carries the page — say
  so in the report).
- Fallback if scripting fails: the video should sit at its poster/first frame, not a
  black box.

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
3. Verify autoplay works in the served page (muted + playsInline present in DOM, and
   the element actually reports playing — see Video QA).
4. Only then add scroll-driven behavior (ScrollTrigger scrub/pin or the rAF
   controller) if the design calls for it — re-encoded with dense keyframes — with the
   plain autoplay version as the reduced-motion/mobile path.
5. Grade both modes for the final report: HERO AUTOPLAY VIDEO PASS/FAIL,
   SCROLL-DRIVEN VIDEO PASS/FAIL. At least one must PASS; otherwise the video
   requirement is FAILED and the report says exactly why.
