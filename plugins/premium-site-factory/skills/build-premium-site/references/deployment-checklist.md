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

## Video QA pass (blocking)

The site must ship at least one real video (`video-direction.md`). Verify against the
BUILT site, not the source you think you wrote. If any check fails and cannot be fixed,
the final report must say `VIDEO REQUIREMENT: FAILED` with the exact reason — never
report success without a playing video.

- [ ] At least one `<video>` element exists in the served page
      (`curl -s <url> | grep -c '<video'` ≥ 1)
- [ ] The referenced video file exists locally under `public/assets/video/` or
      `public/media/video/` and is a real video, not an empty placeholder
      (size > ~100KB AND `ffprobe` reports a video stream with duration > 1s — or, if
      ffprobe is unavailable, the file plays as the page background and its size is
      plausible for its duration)
- [ ] The page/section where the video appears is reachable (curl the URL, confirm the
      section renders)
- [ ] Autoplay videos are `muted` and `playsInline` (and muted is ALSO set via
      ref/effect — React may drop the SSR attribute), `loop` where intended
- [ ] A poster image exists and is wired up; reduced-motion shows a complete page
- [ ] Video file size within targets (hero ≤ 4MB; nothing absurd shipped)
- [ ] No token or secret appears in the video pipeline's source, logs, or generated
      assets; `.env.local` remains gitignored (secret scan still green after video work)

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
