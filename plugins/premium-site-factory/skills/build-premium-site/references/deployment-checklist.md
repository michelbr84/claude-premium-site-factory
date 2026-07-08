# QA & Deployment Checklist

Run this after the site is content-complete, before the final report.

## Anti-clone pass (blocking)

The factory must not have a house style. Answer each honestly; any "no" means redesign
the failing part before shipping — do not rationalize.

- [ ] The visual thesis in `SITE_BRIEF.md` names this business, and the shipped palette,
      type, and motion actually follow it
- [ ] Palette test: dark-with-gold/champagne only if the thesis justified it for THIS
      business (not because previous sites looked that way)
- [ ] Metaphor test: no automotive language or imagery (fleet, showroom, horsepower,
      chauffeur, "concierge") unless the business is automotive/hospitality and it fits
- [ ] Signature section is industry-specific: a route/delivery map appears only when
      geography is genuinely the product (delivery zones, service areas, real estate) —
      never as the default centerpiece
- [ ] Copy voice matches the industry pattern (a clinic reassures, a law firm is precise,
      a SaaS is outcome-led…) — headlines contain no recycled luxury-rental phrasing
- [ ] CTA type fits the business (booking / consultation / demo / datasheet / quote —
      not WhatsApp-concierge by default)
- [ ] Swap test: imagine this design under a different industry's logo — if it would fit
      unchanged, it is generic; sharpen the industry-specific elements
- [ ] Structure test: section order/labels were chosen for this brand, not copied from a
      reference site or a previous run

## Video QA pass (blocking) — active experience required

The site must ship an ACTIVE video experience (`video-direction.md`): the video must
visibly play on load (hero autoplay) and/or visibly advance with scroll (scroll-driven).
A static `<video>` tag does not pass. Verify against the BUILT site, not the source you
think you wrote. Grade both modes; at least one must PASS or the final report says
`VIDEO REQUIREMENT: FAILED` with the exact reason — never report success without a
playing video.

File & page basics (prerequisites for either mode):
- [ ] At least one `<video>` element exists and is visible in the served page
      (`curl -s <url> | grep -c '<video'` ≥ 1; not `display:none`, not zero-sized)
- [ ] The referenced video file exists locally under `public/assets/video/` or
      `public/media/video/` and is a real video, not an empty placeholder
      (size > ~100KB AND `ffprobe` reports a video stream with duration > 1s — or, if
      ffprobe is unavailable, the file plays as the page background and its size is
      plausible for its duration)
- [ ] The page/section where the video appears is reachable on localhost (curl the
      URL, confirm the section renders)
- [ ] A poster image exists and is wired up; reduced-motion shows a complete page
- [ ] Video file size within targets (hero ≤ 4MB; nothing absurd shipped)

HERO AUTOPLAY VIDEO — PASS requires all of:
- [ ] `autoPlay`, `loop`, `playsInline` present, and `muted` set BOTH as prop and via
      ref/effect (React may drop the SSR attribute; without it autoplay silently fails)
- [ ] `preload="auto"` (hero) and the file is small enough to start immediately
- [ ] The video visibly plays without any scroll or interaction — verified in the
      running page (e.g. the element reports `paused === false` after load, or two
      DOM/screenshot samples a second apart differ), not assumed from the JSX
- [ ] In the first viewport (a below-the-fold ambience layer does not make hero PASS)

SCROLL-DRIVEN VIDEO — PASS requires all of:
- [ ] Scroll position visibly drives playback: scrolling changes `video.currentTime`
      (ScrollTrigger scrub or rAF controller) — verified by sampling `currentTime` at
      two scroll positions in the running page
- [ ] The scrub source was re-encoded with dense keyframes (`-g 1`) so seeking is
      smooth, and the file stays reasonably sized (short clip)
- [ ] muted + playsInline + poster still present; reduced-motion path shows a complete,
      readable page without the pinned scene
- [ ] Mobile: touch scrolling drives it acceptably, or small screens fall back to the
      autoplay loop (then hero mode must be the one that carries the requirement)

Security (always):
- [ ] No token or secret appears in the video pipeline's source, logs, or generated
      assets; `.env.local` remains gitignored (secret scan still green after video work)

## Music QA pass (non-blocking — only if a soundtrack ships)

Music never blocks the build. If a soundtrack is present (`audio-direction.md`):

- [ ] Audio file is local under `public/assets/audio/` or `public/media/audio/`,
      non-empty, reasonable size (≤ ~4MB; short loop or 1–2 min bed)
- [ ] NO autoplay of audible sound anywhere: no `<audio autoplay>`, no unmuted
      video-with-sound, no play() call outside an explicit user-gesture handler
- [ ] Sound starts ONLY from an explicit control ("Enable sound" / "Play soundtrack" /
      "Ativar trilha"); default state is OFF on every load (no sticky auto-resume)
- [ ] Pause/mute control visible while playing; default volume low (~0.15–0.35)
- [ ] Control is keyboard-accessible with a proper label/`aria-pressed`; doesn't cover
      content or break mobile nav; audio file is `preload="none"` until enabled
- [ ] If no audio could be generated: `SITE_BRIEF.md` holds the polished soundtrack
      prompt and the report says `MUSIC: PROMPT-ONLY` (or `MUSIC: FAILED` with reason)

## Build & code
- [ ] `npx tsc --noEmit` clean
- [ ] `npm run lint` clean (if configured)
- [ ] `npm run build` succeeds
- [ ] No console errors on load in dev

## Secrets
- [ ] `bash scripts/secret-scan.sh` passes
- [ ] `.gitignore` covers `.env*` (except `.env.example`), `.local/`, `.next/`
- [ ] `git ls-files` shows no env file except `.env.example`
- [ ] No token substring appears in `.next/` build output

## Content & navigation
- [ ] Every nav anchor scrolls to an existing section `id`
- [ ] Every CTA resolves (anchor / `mailto:` / `tel:` / `https://wa.me/...`)
- [ ] Exactly one `h1`; heading levels don't skip
- [ ] No lorem ipsum, no "TODO", no empty sections
- [ ] All placeholders listed in `SITE_BRIEF.md`
- [ ] Metadata: `title`, `description`, OG image, favicon
- [ ] Footer year is current; contact data matches the brief

## Visual & responsive
- [ ] 360px, 768px, 1280px: no horizontal overflow, nothing unreadable
- [ ] Text over imagery passes contrast (scrims where needed)
- [ ] Images have `alt`; interactive elements have visible focus
- [ ] `prefers-reduced-motion` yields a complete, readable page
- [ ] Hero media has poster/fallback; page is usable before media loads

## Performance sanity
- [ ] Hero media ≤ ~4MB video / < ~500KB image
- [ ] Images through `next/image` with proper `sizes`
- [ ] Fonts via `next/font` (no layout-shifting font swaps)
- [ ] No unused heavy dependency shipped to the client

## Localhost handoff
- [ ] `scripts/start-localhost.sh` started the server; URL curls back HTML
- [ ] `.local/dev.pid` and `.local/dev.log` exist
- [ ] Report includes URL, port, and stop command
