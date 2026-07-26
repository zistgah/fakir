#!/usr/bin/env bash
# ops/resume.sh — emit RESUME.md: everything a fresh session needs, from live state.
# The point: on 2026-07-25 getting back up to speed cost a dozen retrieval calls
# and still produced a stale baseline (worked from v0.7 when live was v1.0) and a
# design document for a subsystem that already shipped. One file, generated, fixes that.
#   bash ops/resume.sh          # write RESUME.md
#   bash ops/resume.sh --stdout # print it
# © 1993–2026 Abhishek Choudhary. All rights reserved. AyeAI.
set -uo pipefail
cd "$(dirname "$0")/.."
OUT=RESUME.md; [ "${1:-}" = "--stdout" ] && OUT=/dev/stdout

{
echo "# RESUME — generated state, do not hand-edit"
echo
echo "\`ops/resume.sh\` wrote this from the live tree. Regenerate rather than trust it."
echo "Generated $(date -u +%Y-%m-%dT%H:%M:%SZ) · HEAD \`$(git rev-parse --short HEAD)\` on \`$(git rev-parse --abbrev-ref HEAD)\`"
echo
echo "## Read this first"
echo
echo "1. \`ops/contract.json\` — the rules, machine-readable, with a check id each."
echo "2. \`bash ops/verify.sh\` — tells you whether the repo currently satisfies them."
echo "3. This file — what is actually here."
echo
echo "Do not write a design document for anything below. Retrieve it, then extend it."
echo
echo "## Contract status"
echo '```'
bash ops/verify.sh 2>&1 | sed 's/\x1b\[[0-9;]*m//g'
echo '```'
echo
echo "## Declared version"
for f in index.html; do
  [ -e "$f" ] || continue
  v="$(grep -oE 'v[0-9]+\.[0-9]+:' "$f" 2>/dev/null | tail -1 | tr -d ':')"
  echo "- \`$f\` newest changelog marker: **${v:-none found}**"
done
[ -f metadata/misty.json ] && echo "- DOI: $(python3 -c "import json;d=json.load(open('metadata/misty.json'));print(d.get('doi') or 'null')" 2>/dev/null)"
echo
echo "## What is present (grep census — the antidote to reinventing shipped code)"
echo
printf '| capability | marker | present |\n|---|---|---|\n'
census(){ # label, grep pattern, file
  local n; n="$(grep -c "$2" "$3" 2>/dev/null || echo 0)"
  printf '| %s | `%s` | %s |\n' "$1" "$2" "$([ "$n" -gt 0 ] && echo "yes ($n)" || echo "**no**")"
}
if [ -f index.html ]; then
  census "world transit / vehicle swap" "embodimentOn" index.html
  census "launch to another world" "launchTo" index.html
  census "transit arc" "transitPlan" index.html
  census "flight simulator" "flightStep" index.html
  census "point cloud builder" "ZDOME_BUILD.pointcloud" index.html
  census "domain cloud" "data:FAKIR" index.html
  census "ILM language cloud" "ilmCloudData" index.html
  census "clickable AGI pillar" "pillarPicks" index.html
  census "cinematic entrance" "__cinematicEntry" index.html
  census "YouTube walls" "nocookie" index.html
  census "poster gallery" "ZDOME_BUILD.gallery" index.html
fi
echo
echo "## Attestation chain"
echo
echo "- receipts: $(ls -1 attest/receipts/*.json 2>/dev/null | wc -l) ($(ls -1 attest/receipts/*.json.ots 2>/dev/null | wc -l) stamped)"
echo "- newest: $(ls -1 attest/receipts/*.json 2>/dev/null | LC_ALL=C sort | tail -1 | xargs -r basename)"
echo "- archived manifests: $(ls -1 attest/history/*-MANIFEST.sha256 2>/dev/null | wc -l)"
echo
echo "## Last five commits"
echo '```'
git --no-pager log -5 --format='%h %cd %s' --date=short | cut -c1-100
echo '```'
echo
echo "## How to change anything here"
echo
echo "Source the gate; never hand-roll one:"
echo
echo '```sh'
echo '. ops/candor.sh'
echo '# ... make your edits ...'
echo 'candor_push "summary line"   # gate -> commit -> receipt -> stamp -> reseal -> verify -> push'
echo '```'
echo
echo "\`candor_push\` will refuse to push if \`ops/verify.sh\` fails. That is deliberate:"
echo "the seal cannot be forgotten because the function that pushes is the function that seals."
echo
echo "© 1993–2026 Abhishek Choudhary. All rights reserved. AyeAI."
} > "$OUT"
[ "$OUT" = RESUME.md ] && echo "wrote RESUME.md ($(wc -l < RESUME.md) lines)"
