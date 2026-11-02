#!/bin/bash
# Desktop notification when Claude needs attention
# Triggers on: permission prompts, idle prompts, auth events
# Uses osascript on macOS and notify-send on Linux; elsewhere it exits quietly
INPUT=$(cat)
MESSAGE="Claude needs attention"
TITLE="Claude Code"

# jq reads the message and title from the hook input; without it, use the defaults
if command -v jq >/dev/null 2>&1; then
  MESSAGE=$(echo "$INPUT" | jq -r '.message // "Claude needs attention"')
  TITLE=$(echo "$INPUT" | jq -r '.title // "Claude Code"')
fi

if command -v osascript >/dev/null 2>&1; then
  osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\"" 2>/dev/null
elif command -v notify-send >/dev/null 2>&1; then
  notify-send "$TITLE" "$MESSAGE" 2>/dev/null
fi
exit 0
