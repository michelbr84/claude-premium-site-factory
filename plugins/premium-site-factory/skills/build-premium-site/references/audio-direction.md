# Audio Direction — optional consent-gated soundtrack

A premium site MAY ship a soundtrack layer. It is always optional, always non-blocking
(a failed soundtrack never fails the build), and governed by one absolute rule:

**Sound NEVER plays without an explicit user action. Ever.**

No autoplaying audio, no unmuted video-with-sound, no "ambient by default", no sticky
auto-resume on the next visit. Browsers block audible autoplay anyway (Chrome/Safari
autoplay policies), so a site that tries doesn't just violate UX — it breaks. Default
state is OFF on every page load.

## When to ship one

Ship a soundtrack when the user asks for it, or when the brand world clearly benefits
(cinematic hospitality, wellness, high-end showcase). Skip it silently for businesses
where it would feel wrong (clinics, law firms, most B2B) unless requested — report
`MUSIC: SKIPPED` in that case.

## The consent UI — `SoundToggle`

Create `src/components/ui/SoundToggle.tsx` (client component):

- A small, elegant control labeled in the site's language: "Enable sound" /
  "Play soundtrack" / "Ativar trilha". Placement: hero corner or fixed footer corner —
  visible but never covering content or nav, safe on mobile.
- Uses a single `<audio>` element (or `new Audio(src)`) with `preload="none"` — zero
  network/CPU cost until the user opts in. `loop` for beds/loops.
- `play()` is called ONLY inside the click handler (the user gesture). Start at low
  volume (`0.15–0.35`), optionally with a short fade-in.
- While playing, the control becomes a pause/mute toggle (same spot, clear state).
- Accessibility: keyboard operable, `aria-pressed` state, descriptive `aria-label`,
  visible focus ring. Respect `prefers-reduced-motion` users' calm: the toggle is
  fine, but consider skipping any pulsing/equalizer animation on it.
- Do not persist "on" across loads. Persisting "off" is fine.
- Pause when the tab is hidden (`visibilitychange`) — polite and battery-friendly.

## Producing the audio — the ladder

Work down; stop at the first success. Never block the site on audio.

1. **Replicate MiniMax Music (token present).** Prefer `minimax/music-2.6`; fall back
   to `minimax/music-2.5` if 2.6 is unavailable (verify the slug exists at build time
   via the API/site; a newer verified MiniMax music model is also acceptable — never
   guess a slug).
   - Key inputs (music-2.6): `prompt` (style/mood/key/BPM/genre/instruments — derive
     from the visual thesis), `is_instrumental: true` for a site bed (no lyrics
     needed; this is the usual choice), or `lyrics` with structure tags
     (`[Intro]`/`[Verse]`/`[Chorus]`/`[Outro]`) when a vocal piece is truly wanted;
     `audio_format` mp3 (default) or wav; optional `seed` for reproducibility.
     Output: an audio file (songs up to ~6 min; ask for a short structure).
   - Generate ONE short tasteful piece (a 1–2 min bed or a loopable cue), not an
     album. Request mp3 at default bitrate; keep the shipped file ≤ ~4MB (re-encode
     with ffmpeg if needed, e.g. `-b:a 128k`, and trim to the useful section).
   - Save under `public/assets/audio/` (or `public/media/audio/`), e.g.
     `soundtrack.mp3`. Wire into `SoundToggle`.
   - Same token rules as everything else: read from env server/script-side, never
     print, never commit, never `NEXT_PUBLIC_*`.
   - Music models are slow (often 1–3+ min) — poll patiently, handle failure per-asset.
2. **Generation unavailable or failed → prompt-only.** Write a polished, final
   soundtrack prompt (style, mood, tempo, instrumentation, structure tags, target
   length) into `SITE_BRIEF.md`, extend `scripts/generate-assets.mjs` (or a
   `generate-audio.mjs`) ready to run later, and ship the `SoundToggle` only if a
   placeholder exists — otherwise leave the component out and report
   `MUSIC: PROMPT-ONLY` (where the prompt lives).
3. **Procedural placeholder — only if tasteful.** A quiet ambient bed can be made
   locally (e.g. ffmpeg-synthesized layered sine/noise drone, heavily lowpassed and
   faded). Ship it ONLY if it genuinely sounds calm and premium — an annoying
   placeholder is worse than none. When in doubt, prompt-only.

If nothing ships, that is a fine outcome: report `MUSIC: PROMPT-ONLY` or
`MUSIC: FAILED (reason)` honestly. Never claim a soundtrack exists when it doesn't.

## Reporting

The final report's music line must include: status (`SHIPPED` / `PROMPT-ONLY` /
`FAILED` / `SKIPPED`); for shipped audio — file path, size, duration, generation model
(e.g. `minimax/music-2.6` via Replicate, or procedural), and confirmation that playback
requires explicit user action (name the control) with default-off state.

## Licensing note

Generated music comes with the generating platform's usage terms; note in
`SITE_BRIEF.md` that the user should review Replicate/MiniMax terms for commercial use
of generated audio. Never ship copyrighted commercial tracks.
