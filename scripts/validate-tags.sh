#!/usr/bin/env bash
# validate-tags.sh — coverage + least-privilege check for a skill's allowed-tools Bash patterns.
#
# Heuristic pre-flight for skill-doctor's meta-params pass: it approximates Claude Code's Bash
# matcher so you can spot gaps and over-grants BEFORE approving a suggested allowed-tools edit.
# It does NOT replace the real proof — running the skill once with the rules in place and seeing
# zero permission prompts and zero denials.
#
# Usage:
#   bash validate-tags.sh [skill_dir]
#       reads the Bash(...) patterns from SKILL.md frontmatter allowed-tools.
#   bash validate-tags.sh [skill_dir] "Bash(git clone *)" "Bash(mkdir -p ~/.explore/*)" ...
#       tests PROPOSED patterns from argv without editing the file (suggest-before-approve).
#
# Exit 0 = every command covered, no over-grants. Exit 1 = gaps, over-grants, or nothing enumerated.
# Portable to macOS bash 3.2.

set -euo pipefail

SKILL_DIR="${1:-.}"
if [ "$#" -gt 0 ]; then shift; fi
MD="$SKILL_DIR/SKILL.md"
[ -f "$MD" ] || { echo "no SKILL.md at $SKILL_DIR"; exit 1; }

tmp_cmds="$(mktemp)"; tmp_pats="$(mktemp)"
trap 'rm -f "$tmp_cmds" "$tmp_pats"' EXIT

# --- 1. patterns: argv (proposed) or SKILL.md frontmatter (current) -----------
if [ "$#" -gt 0 ]; then
  for p in "$@"; do printf '%s\n' "$p"; done > "$tmp_pats"
else
  awk '/^---[[:space:]]*$/{c++; next} c==1{print} c>=2{exit}' "$MD" \
    | grep -oE 'Bash\([^)]*\)' > "$tmp_pats" || true
fi

# --- 2. commands the skill runs -----------------------------------------------
# primary: ! `...` dynamic-context injections in SKILL.md (each runs as a Bash call on load)
grep -oE '!`[^`]+`' "$MD" 2>/dev/null | sed 's/^!`//; s/`$//' >> "$tmp_cmds" || true
# secondary: external-tool calls in scripts/ (a script is itself one Bash call, but listed so you
# can scope anything you invoke directly)
if [ -d "$SKILL_DIR/scripts" ]; then
  grep -rhoE '\b(git|gh|glab|bun|npm|npx|node|deno|mkdir|cp|mv|rm|curl|wget|jq|rg|fd|docker|kubectl)\b[^|&;<>]*' \
    "$SKILL_DIR/scripts" 2>/dev/null | sed 's/[[:space:]]*$//' >> "$tmp_cmds" || true
fi
sort -u "$tmp_cmds" -o "$tmp_cmds"

# --- 3. matcher: approximate CC Bash semantics --------------------------------
READONLY_BUILTINS=" ls cat echo pwd head tail grep find wc which diff stat du cd read "
READONLY_GIT=" status log diff show branch tag describe rev-parse ls-files "

is_readonly() {   # $1 full command -> 0 if CC runs it without a prompt
  local first sub
  first="${1%% *}"
  case "$READONLY_BUILTINS" in *" $first "*) return 0;; esac
  if [ "$first" = "git" ]; then
    sub="$(printf '%s' "$1" | awk '{print $2}')"
    case "$READONLY_GIT" in *" $sub "*) return 0;; esac
  fi
  return 1
}

pat_body() { local p="${1#Bash(}"; printf '%s' "${p%)}"; }

matches() {       # $1 pattern body, $2 command
  local pat="$1" cmd="$2" prefix
  pat="${pat/%:\*/ *}"                       # trailing :*  ->  space-*
  case "$pat" in
    *" *")
      case "$pat" in
        *"*"*"*") : ;;                        # 2+ wildcards -> glob only
        *) prefix="${pat% \*}"; [ "$cmd" = "$prefix" ] && return 0 ;;  # single trailing * -> bare ok
      esac ;;
  esac
  # shellcheck disable=SC2053
  [[ "$cmd" == $pat ]] && return 0           # glob match; word boundaries come from literal spaces
  return 1
}

# --- 4. coverage --------------------------------------------------------------
echo "allowed-tools coverage — $SKILL_DIR"
echo ""
gaps=0; ncmds=0
while IFS= read -r cmd; do
  [ -n "$cmd" ] || continue
  ncmds=$((ncmds+1))
  hit=""
  while IFS= read -r p; do
    [ -n "$p" ] || continue
    if matches "$(pat_body "$p")" "$cmd"; then hit="$p"; break; fi
  done < "$tmp_pats"
  if [ -n "$hit" ]; then
    printf "  [ok]   %-42s <= %s\n" "$cmd" "$hit"
  elif is_readonly "$cmd"; then
    printf "  [--]   %-42s (read-only builtin — no rule needed)\n" "$cmd"
  else
    printf "  [GAP]  %-42s NO PATTERN — will prompt at runtime\n" "$cmd"
    gaps=$((gaps+1))
  fi
done < "$tmp_cmds"

if [ "$ncmds" -eq 0 ]; then
  echo "  (no commands enumerated)"
  echo ""
  echo "WARN: nothing to check — the skill may build commands dynamically or keep them outside"
  echo "      SKILL.md/scripts. Validate by dry-run instead (run it; watch for permission prompts)."
  exit 1
fi

# --- 5. over-grants -----------------------------------------------------------
echo ""
echo "pattern usage"
overs=0; npats=0
while IFS= read -r p; do
  [ -n "$p" ] || continue
  npats=$((npats+1))
  used=""
  while IFS= read -r cmd; do
    [ -n "$cmd" ] || continue
    if matches "$(pat_body "$p")" "$cmd"; then used=1; break; fi
  done < "$tmp_cmds"
  if [ -n "$used" ]; then
    printf "  [ok]  %s\n" "$p"
  else
    printf "  [CUT] %s  — matches nothing the skill runs (over-grant)\n" "$p"
    overs=$((overs+1))
  fi
done < "$tmp_pats"
[ "$npats" -eq 0 ] && echo "  (no Bash patterns found)"

# --- 6. verdict ---------------------------------------------------------------
echo ""
if [ "$gaps" -eq 0 ] && [ "$overs" -eq 0 ]; then
  echo "TIGHT — every command covered, no over-grants. Confirm with a real dry-run before approving."
  exit 0
fi
echo "LOOSE — $gaps gap(s), $overs over-grant(s). Tighten the patterns, re-run, then dry-run before approving."
exit 1
