# zistgah-dome — THE Zistgah virtual dome, as an app/lib

One dome, everywhere. This is the complete zistgah.org landing experience — DOME7 diagrid
shell + clustered-column arcade, interior first-person hall, oculus **time scrub** (drag the
oculus), the ten-calendar **CHAKRA** strip + instrument dial, the **flight system** (drone /
pilot: keyboard, gamepad, on-screen sticks; thread the oculus and fly out to the worlds of the
Zistgah cosmography), exhibit pedestals with engraved plaques + hover cards, rim inscriptions,
nebula/glyph sky, meteors, dawn cycle, settings panel, frame-budget manager — factored into a
reusable library. **Verbatim, with exactly 9 marked config seams** (`grep ZDOME-SEAM dome.js`).
Unconfigured, it is the zistgah.org landing.

## Files
- `dome.js` — the experience (seamed verbatim; provenance header inside)
- `chakra-core.js` — calendars/astronomy, computed never looked up (project-ilm/chakra)
- `dome.css` — the landing stylesheet

## Contract
1. **Scaffold**: the host page must provide the landing DOM (canvases `nebula` `gl`, `calbar`,
   `brand`, `setBtn` `settings`, `fractal`, `themeBtn`, `hot`, `scrubline`, `veil`, a `<main>`
   with sections `arrival` `domains` `exhibits` `threads` + `pop`, flight UI `horizon` `hud`
   `stickL` `stickR`, `toast`, footer). Copy it from `explore/index.html` here or zistgah.org.
2. **Load order**: THREE r128 → *your config script* (sets `window.ZISTGAH_DOME`) →
   `chakra-core.js` → `dome.js`.
3. **Config** (`window.ZISTGAH_DOME`, every key optional; defaults = zistgah.org):
   - `display(api)` — mount your project's geometry. `api = {THREE, scene, G, camera,
     renderer, R, D, domePoint, makeDome}`. Add to **`G`** (the hall group) so your display
     turns with the dome. FAKIR mounts its 9,350-point lattice here.
   - `pillars` (3 rim inscriptions), `exhibitNames` (4 pedestals) + `exhibitSubs` (hover text),
   - `domains`, `marks`, `art`, `threads` — the below-fold 2D content the dome scrolls out to.
4. Settings persist under the shared `zistgah-scene` key — the dome behaves identically on
   every property, by design.

Canonical home: the zistgah org (to be lifted out unchanged). Do not fork the dome; configure it.
© 1993–2026 Abhishek Choudhary. All rights reserved. · AyeAI · Factored with Claude Fable 5 (Anthropic).
