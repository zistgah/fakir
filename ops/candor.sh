#!/usr/bin/env bash
# ops/candor.sh — the gate AND the seal, as one call. Source this from any
# apply script; never hand-roll a gate again.
#
#   . ops/candor.sh
#   candor_push "what this change is"     # gate → seal → receipt → stamp → commit → push
#
# Why one function: on 2026-07-25 a push landed with no receipt and a broken
# MANIFEST because sealing lived in a separate script that was simply forgotten.
# The only durable fix is that pushing and sealing cannot be separated.
# © 1993–2026 Abhishek Choudhary. All rights reserved. AyeAI.

CANDOR_HOST="${CANDOR_HOST:-$(hostname 2>/dev/null || echo unknown)}"
CANDOR_NAME="${CANDOR_NAME:-Abhishek Choudhary}"
CANDOR_EMAIL="${CANDOR_EMAIL:-abhishek@ayeai.in}"

_c_say(){ printf '\n\033[1m%s\033[0m\n' "$*"; }
_c_die(){ printf '\033[31m%s\033[0m\n' "$*" >&2; return 1; }

# candor_gate ACTION  → echoes the reason on stdout, non-zero if declined.
# Tolerant parsing: "PUSH fix" / "PUSH, fix" / "PUSH: fix" / lower case / spaces.
candor_gate(){
  local want="$1" line word reason
  printf '  Type %s plus a reason ("%s fix", "%s, fix" and "%s: fix" all work).\n' "$want" "$want" "$want" "$want" >&2
  printf '  > ' >&2; read -r line || true
  word="$(printf '%s' "$line" | awk '{print toupper($1)}' | tr -d ',:;.')"
  reason="$(printf '%s' "$line" | sed -E 's/^[[:space:]]*[A-Za-z]+[,:;.]?[[:space:]]*//' | sed -E 's/[[:space:]]+$//')"
  [ "$word" = "$want" ] || return 1
  if [ -z "$reason" ]; then printf '  reason: ' >&2; read -r reason || true; fi
  [ -n "$reason" ] || { printf '  a reason is required — it is the substance of the intent\n' >&2; return 1; }
  printf '%s' "$reason"
}

# candor_receipt ACTION COMMIT REASON [NOTE] → writes attest/receipts/<UTC>-ACTION.json
candor_receipt(){
  local action="$1" commit="$2" reason="$3" note="${4:-}" utc out
  utc="$(date -u +%Y%m%dT%H%M%SZ)"
  out="attest/receipts/${utc}-${action}.json"
  mkdir -p attest/receipts
  REPO_NAME="$(git config --get remote.origin.url | sed -E 's#.*[:/]([^/]+/[^/]+?)(\.git)?$#\1#')"
  python3 - "$out" "$action" "$commit" "$reason" "$utc" "$CANDOR_HOST" "$REPO_NAME" "$note" <<'PY'
import json,sys
out,action,commit,reason,utc,host,repo,note = sys.argv[1:9]
p={"action":action,"reason":reason,"utc":utc,"host":host}
if note: p["note"]=note
json.dump({"_type":"https://in-toto.io/Statement/v1",
  "predicateType":"https://project-ilm.org/attestations/candor/v1",
  "subject":[{"name":repo,"digest":{"gitCommit":commit}}],
  "predicate":p}, open(out,"w"), indent=4)
open(out,"a").write("\n")
PY
  echo "$out"
}

# candor_stamp FILE...  → OTS, announcing the silent wait, never fabricating
candor_stamp(){
  if ! command -v ots >/dev/null 2>&1; then
    echo "  ots client absent — nothing stamped, nothing fabricated."
    echo "  Install opentimestamps-client and rerun ops/candor_reseal to add proofs."
    return 0
  fi
  echo "  stamping $# file(s). OpenTimestamps waits on public calendars: silent for"
  echo "  up to ~30 s each, and keystrokes you type will echo back. That is not breakage."
  local f
  for f in "$@"; do
    [ -e "$f" ] || continue
    if [ -e "${f}.ots" ]; then echo "    SKIP ${f}.ots exists — proofs are never overwritten"; continue; fi
    printf '    %s ... ' "$f"
    if ots stamp "$f" >/dev/null 2>&1; then echo "done"; else echo "FAILED (left unstamped, not faked)"; fi
  done
}

# candor_reseal → rotate the outgoing manifest + proof into history, rebuild, verify.
# ORDER MATTERS and this is where it is enforced: callers must stamp receipts
# BEFORE calling this, so the receipts and their .ots land inside the manifest.
# Building the manifest first is what left a receipt proof outside it on 25 Jul.
candor_reseal(){
  local stamp; stamp="$(date -u +%Y%m%dT%H%M%SZ)"
  mkdir -p attest/history
  if [ -f MANIFEST.sha256 ]; then
    cp MANIFEST.sha256 "attest/history/${stamp}-MANIFEST.sha256"
    if [ -f MANIFEST.sha256.ots ]; then
      cp MANIFEST.sha256.ots "attest/history/${stamp}-MANIFEST.sha256.ots"
      rm -f MANIFEST.sha256.ots
    fi
    echo "  outgoing manifest and proof archived → attest/history/${stamp}-*"
  fi
  git add -A >/dev/null
  git ls-files -z | grep -zv '^MANIFEST.sha256$' | xargs -0 sha256sum > MANIFEST.sha256
  echo "  MANIFEST.sha256 rebuilt: $(grep -c . MANIFEST.sha256) entries"
  sha256sum -c MANIFEST.sha256 >/dev/null 2>&1 || { _c_die "rebuilt manifest does not verify"; return 1; }
  echo "  verifies clean"
}

# candor_push "summary line" → the whole gated write, in the mandated order.
candor_push(){
  local summary="$1" reason receipt
  _c_say "GATE"
  git --no-pager diff --stat HEAD 2>/dev/null | tail -3
  reason="$(candor_gate PUSH)" || { _c_say "ABORTED — tree left verified in place, nothing pushed"; return 0; }

  _c_say "COMMIT"
  git add -A
  git -c user.name="$CANDOR_NAME" -c user.email="$CANDOR_EMAIL" commit --quiet -m "$summary

$reason

(c) 1993-2026 Abhishek Choudhary. All rights reserved. AyeAI." || { _c_die "nothing to commit"; return 1; }
  local head; head="$(git rev-parse HEAD)"
  echo "  $(git rev-parse --short HEAD)"

  _c_say "RECEIPT"
  receipt="$(candor_receipt PUSH "$head" "$reason")"
  echo "  $receipt"

  _c_say "OTS — receipts first, so the reseal covers them"
  candor_stamp "$receipt"

  _c_say "RESEAL"
  candor_reseal || return 1
  candor_stamp MANIFEST.sha256

  _c_say "SEAL COMMIT"
  git add -A
  git -c user.name="$CANDOR_NAME" -c user.email="$CANDOR_EMAIL" \
      commit --quiet -m "attest: Candor receipt + reseal [$(git rev-parse --short "$head")]"
  echo "  $(git rev-parse --short HEAD)"

  _c_say "VERIFY CONTRACT"
  if [ -x ops/verify.sh ] || [ -f ops/verify.sh ]; then
    bash ops/verify.sh || { _c_die "contract violated — NOT pushing"; return 1; }
  else
    echo "  ops/verify.sh absent — skipped"
  fi

  _c_say "PUSH"
  git push --quiet origin "$(git rev-parse --abbrev-ref HEAD)"
  echo "  pushed $(git rev-parse --short HEAD)"
}
