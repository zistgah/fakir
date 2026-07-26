# RESUME — generated state, do not hand-edit

`ops/resume.sh` wrote this from the live tree. Regenerate rather than trust it.
Generated 2026-07-26T02:44:58Z · HEAD `9fc2bb5` on `main`

## Read this first

1. `ops/contract.json` — the rules, machine-readable, with a check id each.
2. `bash ops/verify.sh` — tells you whether the repo currently satisfies them.
3. This file — what is actually here.

Do not write a design document for anything below. Retrieve it, then extend it.

## Contract status
```
contract 2.0.0 — 9fc2bb5
    ok    C1-manifest-verifies   113 files verify
   FAIL   C2-manifest-complete   1 absent, e.g. attest/receipts/20260725T202354Z-PUSH.json.ots
    ok    C3-receipt-per-commit  attested from the first receipt onward (1 older commits predate Candor)
    ok    C4-receipt-schema      13 receipts conform
    ok    C5-proofs-immutable    every archived manifest keeps its .ots
    ok    C6-copyright           line present; affiliation clean

CONTRACT VIOLATED — 1 of 6 checks failing
```

## Declared version
- `index.html` newest changelog marker: **v1.0**
- DOI: 10.5281/zenodo.21436550

## What is present (grep census — the antidote to reinventing shipped code)

| capability | marker | present |
|---|---|---|
| world transit / vehicle swap | `embodimentOn` | yes (4) |
| launch to another world | `launchTo` | yes (3) |
| transit arc | `transitPlan` | yes (3) |
| flight simulator | `flightStep` | yes (2) |
| point cloud builder | `ZDOME_BUILD.pointcloud` | yes (3) |
| domain cloud | `data:FAKIR` | yes (1) |
| ILM language cloud | `ilmCloudData` | yes (2) |
| clickable AGI pillar | `pillarPicks` | yes (4) |
| cinematic entrance | `__cinematicEntry` | yes (2) |
| YouTube walls | `nocookie` | yes (1) |
| poster gallery | `ZDOME_BUILD.gallery` | yes (2) |

## Attestation chain

- receipts: 13 (13 stamped)
- newest: 20260725T202354Z-PUSH.json
- archived manifests: 7

## Last five commits
```
9fc2bb5 2026-07-25 attest: Candor receipts + reseal [dc90cca]
dc90cca 2026-07-25 FAKIR dome v2: ILM cloud, clickable AGI pillar, cinematic oculus entrance; v1 fro
1259841 2026-07-20 attest: Candor receipts [7728c6a]
7728c6a 2026-07-20 fakir v0.7: clickable small-point cluster under the oculus (window-level picking 
62ba0e4 2026-07-19 attest: Candor receipts [957c4ff]
```

## How to change anything here

Source the gate; never hand-roll one:

```sh
. ops/candor.sh
# ... make your edits ...
candor_push "summary line"   # gate -> commit -> receipt -> stamp -> reseal -> verify -> push
```

`candor_push` will refuse to push if `ops/verify.sh` fails. That is deliberate:
the seal cannot be forgotten because the function that pushes is the function that seals.

© 1993–2026 Abhishek Choudhary. All rights reserved. AyeAI.
