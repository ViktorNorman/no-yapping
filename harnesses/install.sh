#!/usr/bin/env bash
# Install the no-yapping rule into the right place for your coding harness.
#
# Usage:  ./harnesses/install.sh <harness> [target-dir]
#   harness:    claude | agents | codex | cursor | copilot | gemini | windsurf
#   target-dir: project root to install into (default: current directory)
#
# SKILL.md is the single source of truth. For non-Claude harnesses this script
# strips the YAML frontmatter and writes the rule body into the file that
# harness reads. AGENTS.md is read natively by Codex, Cursor, Copilot, Windsurf,
# Aider, Zed, Jules and ~30 other tools — use `agents` if yours isn't listed.
set -euo pipefail

HARNESS="${1:-}"
DEST="${2:-.}"
SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_MD="$SKILL_DIR/SKILL.md"

usage() { echo "Usage: $0 <claude|agents|codex|cursor|copilot|gemini|windsurf> [target-dir]"; exit 1; }
[ -z "$HARNESS" ] && usage

# Rule body = SKILL.md minus YAML frontmatter, stopping before the
# Claude-only "## Reference files" section so the output is self-contained.
body() {
  awk 'BEGIN{fm=0}
       /^## Reference files/{exit}
       /^See `examples/{exit}
       /^---[[:space:]]*$/{fm++; next}
       fm>=2{print}' "$SKILL_MD"
}

append_section() {  # $1 = file path
  local f="$1"; mkdir -p "$(dirname "$f")"
  { echo; echo "<!-- no-yapping — https://github.com/<you>/no-yapping -->"; body; } >> "$f"
  echo "Appended no-yapping rules to $f"
}

case "$HARNESS" in
  claude)
    d="$DEST/.claude/skills/no-yapping"; mkdir -p "$d/examples"
    cp "$SKILL_MD" "$d/SKILL.md"
    cp "$SKILL_DIR/SPEC.md" "$d/SPEC.md"
    cp -r "$SKILL_DIR/examples/." "$d/examples/"
    echo "Installed Claude skill at $d/" ;;
  agents|codex)   append_section "$DEST/AGENTS.md" ;;
  gemini)         append_section "$DEST/GEMINI.md" ;;
  copilot)        append_section "$DEST/.github/copilot-instructions.md" ;;
  windsurf)       append_section "$DEST/.windsurf/rules/no-yapping.md" ;;
  cursor)
    f="$DEST/.cursor/rules/no-yapping.mdc"; mkdir -p "$(dirname "$f")"
    desc=$(grep -m1 '^description:' "$SKILL_MD" | sed 's/^description:[[:space:]]*//')
    # Agent Requested: a description + no globs = Cursor loads it dynamically when your
    # prompt is relevant ("no yapping" / "be terse"), or force it with @no-yapping.
    # Prefer it always-on? Change the line below to: alwaysApply: true
    { echo "---";
      echo "description: ${desc:-no-yapping — terse, code-first coding mode}";
      echo "alwaysApply: false";
      echo "---"; echo;
      body; } > "$f"
    echo "Installed Cursor rule (Agent Requested) at $f — say 'no yapping' or @no-yapping to invoke" ;;
  *) echo "Unknown harness: $HARNESS"; usage ;;
esac
