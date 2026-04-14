#!/usr/bin/env bash
# make-card.sh — converts an agent's business card PDF to an MMS-ready JPG.
#
# Usage:
#   ./make-card.sh <input.pdf> <agent-slug>
#
# Example:
#   ./make-card.sh ~/Downloads/jane-smith-card.pdf jane-smith
#   → writes ./jane-smith.jpg (1200px wide, progressive, ~150KB)
#
# Requirements: pdftoppm (poppler-utils) and convert (ImageMagick).
#   macOS: brew install poppler imagemagick
#   Linux: apt-get install poppler-utils imagemagick

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <input.pdf> <agent-slug>" >&2
  exit 1
fi

INPUT_PDF="$1"
SLUG="$2"
OUT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT_JPG="$OUT_DIR/$SLUG.jpg"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

if [[ ! -f "$INPUT_PDF" ]]; then
  echo "Input PDF not found: $INPUT_PDF" >&2
  exit 1
fi

# Rasterize PDF page 1 at 200 DPI.
pdftoppm -jpeg -r 200 -f 1 -l 1 "$INPUT_PDF" "$TMP_DIR/page"

RAW="$TMP_DIR/page-1.jpg"
if [[ ! -f "$RAW" ]]; then
  echo "pdftoppm failed to produce a JPEG." >&2
  exit 1
fi

# Resize to 1200px wide, strip metadata, progressive JPEG, ~82% quality.
# This lands at ~150-200KB which is well under Twilio's 600KB MMS cap.
convert "$RAW" -resize 1200x -strip -interlace Plane -quality 82 "$OUT_JPG"

SIZE_BYTES=$(stat -c%s "$OUT_JPG" 2>/dev/null || stat -f%z "$OUT_JPG")
SIZE_KB=$((SIZE_BYTES / 1024))

echo "Wrote: $OUT_JPG (${SIZE_KB}KB)"
echo ""
echo "Next:"
echo "  1. git add cards/$SLUG.jpg"
echo "  2. git commit -m 'Add $SLUG business card'"
echo "  3. git push"
echo "  4. Public URL (after Netlify deploy):"
echo "     https://dusefg.netlify.app/cards/$SLUG.jpg"
