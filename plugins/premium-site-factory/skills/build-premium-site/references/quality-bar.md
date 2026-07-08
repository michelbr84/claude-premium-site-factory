# Quality Bar

The result must feel like a premium agency concept, not a template. Judge the finished site
against every line below before reporting success.

## Acceptance criteria

- Complete page: every required section from `site-structure.md` exists with real copy.
- Feels designed, not generated: a deliberate visual system, not framework defaults.
- Specific to this business: passes the anti-clone pass in `deployment-checklist.md` —
  a written visual thesis, industry-appropriate palette/voice/CTA, and a signature
  section this industry earns (no recycled dark/gold, automotive metaphors, or route
  maps by default).
- Strong hero: full-screen, cinematic, readable headline, working CTAs.
- Clear positioning: a visitor understands in 5 seconds what the company does and for whom.
- Fully responsive: usable and polished at 360px, 768px, 1280px, 1920px.
- Real CTAs: every button and link goes somewhere sensible (anchor, mailto, tel, WhatsApp).
- Motion serves the content: reveals and parallax guide reading; nothing is hidden forever;
  `prefers-reduced-motion` disables nonessential animation.
- Production build passes (`next build` green, no type errors).
- No secrets in tracked files or client bundles (secret scan passes).
- Exactly one `h1`; heading levels are sequential; images have alt text; visible focus states.
- No fabricated legal or numeric claims — placeholders are marked and listed in `SITE_BRIEF.md`.
- `README.md` explains how to run, stop, and configure the project.
- The site is running on localhost when the report is delivered.

## Common failures to avoid

- Generic gradient SaaS template look (purple-to-blue hero, three feature cards, done).
- Too much text — premium reads as restraint; cut every paragraph in half.
- Weak typography: default fonts, timid sizes, no scale contrast between display and body.
- Animations that block or hide content, or janky scroll hijacking.
- No mobile fallback for heavy desktop interactions.
- Enormous hero media with no poster/fallback (multi-MB video, uncompressed PNG).
- Exposed API keys, tokens in client bundles, committed `.env.local`.
- Placeholder contact data that looks real but isn't documented anywhere.
- Broken nav anchors, dead CTA buttons, horizontal scroll on mobile.
- Lorem ipsum or "Your text here" surviving into the final result.
