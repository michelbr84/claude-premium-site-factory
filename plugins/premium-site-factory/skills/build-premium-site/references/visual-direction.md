# Visual Direction

Avoid generic AI-startup design. Every choice below should look deliberate — and every
choice must express the site's written visual thesis (see `industry-patterns.md` for the
per-industry starting points). These are craft rules, not a house style: two sites from
this factory in different industries should share quality, never appearance.

## Typography
- Two families max via `next/font`: a characterful display face (editorial serif, wide
  grotesque, or refined neo-grotesque) + a quiet text face. Never default system stacks.
- Big scale contrast: display sizes 3–8rem+ with tight leading and slight negative
  tracking; body 1–1.125rem with generous leading. Use `clamp()` for fluid scaling.
- Uppercase micro-labels (0.75rem, wide tracking) for section eyebrows work well in
  premium layouts.

## Color
- One dominant background world (deep dark or warm light — pick per brand, don't ship
  both), one ink color, ONE accent used sparingly (CTAs, highlights, live details).
- Near-blacks and near-whites (e.g. `#0A0A0B`, `#FAF9F7`), never pure `#000`/`#FFF` for
  large surfaces. No random multi-color gradients; if gradients appear, they are subtle,
  tonal, and directional.
- Check WCAG AA contrast for all text, including text over imagery (use scrims/overlays).

## Layout & composition
- Editorial, not dashboard: asymmetry, overlapping layers, generous negative space.
- Consistent rhythm: section paddings around 6–10rem desktop / 3–5rem mobile from a
  spacing scale, one max-width container system with intentional full-bleed breaks.
- Numbers, rules, and hairlines (1px borders at low opacity) add precision. Big section
  indices ("01", "02") reinforce the editorial feel.

## Imagery
- Generated or fallback imagery must share one world: same palette, same light, same
  grain. A consistent color-grade (CSS filter or overlay tint) unifies mixed sources.
- No fake readable text inside images, no third-party logos or brand marks, no fake
  license plates, no cluttered AI artifacts (mangled hands, garbled signage) — reject and
  regenerate or fall back to abstract.
- Fallbacks that look intentional: layered radial/conic gradients, SVG noise/grain
  (`feTurbulence`), thin-line geometric SVG compositions, duotone treatments.

## Motion
- Restraint: reveals (opacity + 20–40px translate), parallax under 15%, one or two
  signature moments (hero entrance, signature-section animation). Nothing bounces.
- Durations 0.6–1.2s, eases like `power3.out`/`expo.out`. Stagger text by line or word,
  50–80ms apart.
- Use `gsap` + `@gsap/react` (`useGSAP` hook) with ScrollTrigger; register plugins once in
  a client component. Lenis for smooth scroll only if it stays 60fps.
- Every animation has a reduced-motion path (`prefers-reduced-motion`: show final state).
- Mobile: shorter distances, fewer pinned scenes, no scroll-jacking.

## Tailwind v4 notes
- Design tokens live in `globals.css` under `@theme` (custom properties → utility
  classes). Define brand colors, font families, and spacing there, not in scattered
  arbitrary values.
- Component classes stay in JSX; extract only true primitives (buttons, container,
  section heading) into components, not `@apply` soup.
