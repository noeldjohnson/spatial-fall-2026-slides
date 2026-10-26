#!/bin/bash
# Block accidental edits to protected files
# Customize PROTECTED_PATTERNS below for your project
INPUT=$(cat)

# jq parses the hook input; without it, warn and allow the edit
if ! command -v jq >/dev/null 2>&1; then
  echo "protect-files.sh: jq is not installed, so file protection is off. Install jq to enable it." >&2
  exit 0
fi

TOOL=$(echo "$INPUT" | jq -r '.tool_name')
FILE=""

# Extract file path based on tool type
if [ "$TOOL" = "Edit" ] || [ "$TOOL" = "Write" ]; then
  FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
fi

# No file path = not a file operation, allow
if [ -z "$FILE" ]; then
  exit 0
fi

# ============================================================
# CUSTOMIZE: Add patterns for files you want to protect
# Uses basename matching — add full paths for more precision
# ============================================================
PROTECTED_PATTERNS=(
  "Bibliography_base.bib"
  "settings.json"
)

# Raw data is read-only: block any edit under a Data/raw/ directory
if [[ "$FILE" == */Data/raw/* ]]; then
  echo "Protected path: $FILE is raw data and is read-only. Write derived files to Data/processed/ instead." >&2
  exit 2
fi

BASENAME=$(basename "$FILE")
for PATTERN in "${PROTECTED_PATTERNS[@]}"; do
  if [[ "$BASENAME" == "$PATTERN" ]]; then
    echo "Protected file: $BASENAME. Edit manually or remove protection in .claude/hooks/protect-files.sh" >&2
    exit 2
  fi
done

exit 0
