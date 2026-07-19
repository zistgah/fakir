# FAKIR — Foundational Architecture for Knowledge, Intelligence & Reasoning

**The kernel of UKOP** (Universal Knowledge Operating Platform) — the concrete, executable
substrate under the civilizational-scale reference architecture covering every domain
represented by **UN ISIC · ILO ISCO · UNESCO ISCED**. UKOP is the blueprint; FAKIR is the engine.

**Live:** zistgah.org/fakir/ — the dome IS the front door (`index.html` at the repo root; `docs/` and `explore/` removed)
**DOI (software):** `10.5281/zenodo.21436550` · **DOI (poster corpus):** `10.5281/zenodo.21436552`

## v0.5 — the homepage dome itself, at the root, with the FAKIR dots floating inside

`index.html` **is the zistgah.org landing file** — same inline Three.js build, CHAKRA
strip + dial, oculus time scrub, flight system (thread the oculus, fly to the worlds), exhibit
pedestals, nebula, glyphs, meteors, dawn, settings, **PWA** (`manifest.webmanifest`, `sw.js`, icons at the root — installable, works offline) — transformed in place: 9 marked config seams
(`grep ZDOME-SEAM`) + FAKIR's lattice mounted into the hall group so the 9,350 points turn
with the dome. All features, by construction, because it is the same file.

**Executed, not just parsed:** a jsdom harness boots the whole page headless — 10 calendar
cards render, the seams consume FAKIR's content, the 1,505-row tree builds, search filters
live, the seeding panel opens with full lineage, and `display()` runs in-realm against the
real `makeDome`: 3 family clouds · 9,350 points · 10 layer rings · highlight overlay. Only
GPU rasterization remains for the human eye.

`vendor/zistgah-dome/` stays as the lift-out lib (same seams) for any other property; see its
README for the contract.

**FAKIR's display data:** the exhaustive lattice —
| Family | Levels | Counts | Source |
|---|---|---|---|
| UN ISIC Rev.4 | Section·Division·Group·Class | 21 / 88 / 238 / 419 | UNSD structure file (verbatim, `data/isic_rev4.csv`) |
| ILO ISCO-08 | Major·Sub-major·Minor·Unit | 10 / 43 / 130 / 436 | ILO structure & definitions (`data/isco08.json`) |
| UNESCO ISCED-F 2013 | Broad·Narrow·Detailed | 11 / 29 / 80 | UIS Appendix 1 code list |

**1,505 nodes · 935 leaves × AGI stack L0–L9 (Project ILM) = 9,350 points** under the shell
(L0 at the rim → L9 at the oculus, Ω at the core), turning with the hall. Click a point — or
the ✦ on **any node at any level** in the full tree below the fold — to seed an oracle-gated
**AAB** task (verbatim intent ledger, painted manifest, VGC quests Q1–Q6). *No oracle, no glow.*
Search filters the tree and lights matching leaves in the dome. Citations: `data/SOURCES.md`.

## Poster corpus (`posters/`)
Eleven UKOP · FAKIR · Kaivalyik posters, one deposit (`10.5281/zenodo.21436552`).
`posters/TRADEMARKS.md`: all marks belong to their respective owners; identification use only.

## Provenance & publication
- Seal: `ops/seal.sh` → `MANIFEST.sha256` + OpenTimestamps; superseded proofs archived under
  `attest/history/` — never overwritten.
- Push · Pages ran under typed Candor assertions (`attest/receipts/`, in-toto Statements).
- **Mint policy:** misty-doi has no `newversion` yet, so v0.3 keeps the canonical DOIs above
  (concept DOIs `21436549` / `21436551` anchor the lineage). A version DOI follows once
  misty-doi grows Zenodo's newversion action.
- Refs: Tok DOI `10.5281/zenodo.21402745` · VGC `10.5281/zenodo.21264248`.
- Governance: `CONTRACT.md` → `zistgah/governance` · Licensing per category: `LICENSING.md`.

**Author:** Abhishek Choudhary · **Affiliation:** AyeAI · ORCID 0009-0002-0684-8320
© 1993–2026 Abhishek Choudhary. All rights reserved. · Built with Claude Fable 5 (Anthropic).
