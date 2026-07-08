# QA & Deployment Checklist

Run this after the site is content-complete, before the final report.

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
- [ ] Hero media < ~4MB video / < ~500KB image
- [ ] Images through `next/image` with proper `sizes`
- [ ] Fonts via `next/font` (no layout-shifting font swaps)
- [ ] No unused heavy dependency shipped to the client

## Localhost handoff
- [ ] `scripts/start-localhost.sh` started the server; URL curls back HTML
- [ ] `.local/dev.pid` and `.local/dev.log` exist
- [ ] Report includes URL, port, and stop command
