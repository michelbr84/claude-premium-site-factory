# Changelog

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
