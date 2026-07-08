# Site Structure

Build a complete single-page site (plus anchors) with at least the sections below, in this
order unless the business clearly demands otherwise. Rename sections to fit the brand —
the structure is required, the labels are not.

## 1. Cinematic hero
- Full-screen premium visual: video (muted, autoplay, loop, `playsInline`, poster,
  reduced-motion fallback) or a strong image/generated backdrop with depth.
- Strong short headline (positioning, not a slogan collage), one supporting line.
- Primary CTA + secondary CTA. Fixed or elegant nav with working anchor links.

## 2. Brand manifesto
- 2–4 short elevated lines that say what the brand believes, not what it sells.
- Scroll-triggered reveal (word or line level). This is a statement, not a paragraph.

## 3. Services / What we do
- 3–6 core services in an editorial layout (asymmetric grid, numbered list, or split
  panels). Explicitly avoid the generic three-cards-with-icons SaaS look.
- Each service: name, one sharp sentence, optional detail line.

## 4. Signature visual section
- The memorable centerpiece, grown from the visual thesis and the industry pattern
  (see `industry-patterns.md`): an assembling product walkthrough, a floor plan drawing
  itself, a process timeline, a schematic/trace animation, an ingredient map, an exploded
  view, an abstract brand system — whatever THIS business earns.
- Maps/routes only when geography is genuinely the product (delivery zones, service
  areas, real estate) — never as a default centerpiece.
- SVG + GSAP or lightweight canvas/3D. Must degrade gracefully (static composition) under
  reduced motion and on weak devices.

## 5. Story / Process
- 3–5 steps of how working with the company goes, as a narrative.
- Sticky progress line, counter, or pinned sequence if it helps comprehension.

## 6. Showcase
- Fleet, products, work, categories, or experiences — the concrete offering.
- Desktop: polished interaction (hover reveals, horizontal drag/scroll, layered cards).
- Mobile: simplified native pattern (swipe/scroll-snap), never a broken desktop widget.

## 7. Partners / Customers / Use cases
- Who the company serves, as benefit-oriented cards or segments (not a logo dump unless
  real logos are provided).

## 8. Trust layer
- Stats (marked placeholder if invented), assurance panels, a testimonial (clearly
  placeholder unless provided), certifications/licenses **only if provided or explicitly
  marked as placeholder**.

## 9. Final CTA + footer
- Large memorable closing statement with the main conversion action (WhatsApp, form, call).
- Footer: contact, social, anchor nav, legal line, copyright with current year.

## Cross-cutting requirements
- All nav anchors resolve to section `id`s; smooth-scroll respects reduced motion.
- Every section works at 360px width. No horizontal overflow anywhere.
- Contact actions use real links: `https://wa.me/<number>`, `mailto:`, `tel:`.
- Section order tells one story: promise → belief → offering → proof → action.
