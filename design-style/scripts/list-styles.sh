#!/bin/bash

# Design Style Quick Reference
# This script lists all available design styles from the prompts directory

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║          Available Design Styles for Frontend Development          ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

PROMPTS_DIR="../../../prompts"

if [ -d "$PROMPTS_DIR" ]; then
  echo "📁 Total styles available: $(ls -1 "$PROMPTS_DIR"/*.md 2>/dev/null | wc -l)"
  echo ""
  echo "Design Styles:"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  for file in "$PROMPTS_DIR"/*.md; do
    if [ -f "$file" ]; then
      filename=$(basename "$file" .md)
      echo "  • $filename"
    fi
  done

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "Usage: When building frontend, mention a style name to Claude Code"
  echo "Example: 'Create a landing page with Neo-brutalism style'"
  echo ""
else
  echo "⚠️  Prompts directory not found at: $PROMPTS_DIR"
  exit 1
fi
