#!/usr/bin/env bash
# seal.sh - build MANIFEST.sha256 over tracked files; OTS-stamp it when `ots` exists.
set -euo pipefail
cd "$(dirname "$0")/.."
git ls-files -z | grep -zv '^MANIFEST.sha256$' | xargs -0 sha256sum > MANIFEST.sha256
echo "MANIFEST.sha256: $(wc -l < MANIFEST.sha256) entries"
if command -v ots >/dev/null 2>&1; then
  if [ -e MANIFEST.sha256.ots ]; then echo "SKIP: MANIFEST.sha256.ots exists (never overwrite proofs)";
  else ots stamp MANIFEST.sha256 && echo "OTS: stamped MANIFEST.sha256"; fi
else
  echo "SKIP: ots client not installed - no fabricated proof. Install opentimestamps-client and rerun."
fi
