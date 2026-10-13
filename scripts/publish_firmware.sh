#!/usr/bin/env bash
# Publish a signed Focus Clock firmware to ota/ and point version.json at it.
#
#   scripts/publish_firmware.sh            # use ../focus-clock/firmware/build
#   scripts/publish_firmware.sh --auto     # clocks install it by themselves at night
#   FIRMWARE_DIR=/path/to/firmware scripts/publish_firmware.sh
#
# Then review with `git status`, commit and push. Raise PROJECT_VER in the firmware's
# CMakeLists.txt and rebuild before every release: clocks only update to a higher version.
set -euo pipefail
cd "$(dirname "$0")/.."

FW="${FIRMWARE_DIR:-../focus-clock/firmware}"
BASE_URL="${BASE_URL:-https://ramgopal.dev/focus-clock}"
AUTO=false
[[ "${1:-}" == "--auto" ]] && AUTO=true

BIN="$FW/build/focus_clock.bin"
DESC="$FW/build/project_description.json"
[[ -f "$BIN" && -f "$DESC" ]] || { echo "No build found in $FW/build. Run idf.py build first." >&2; exit 1; }
[[ "$BIN" -nt "$FW/CMakeLists.txt" ]] || { echo "The build is older than CMakeLists.txt; rebuild first." >&2; exit 1; }

VERSION=$(python3 -c "import json,sys; print(json.load(open(sys.argv[1]))['project_version'])" "$DESC")
[[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "Odd version '$VERSION'" >&2; exit 1; }
# Only signed images: the signing step leaves an unsigned copy next to the signed one
[[ -f "$FW/build/focus_clock-unsigned.bin" ]] || { echo "No unsigned twin found: is signing on? Refusing." >&2; exit 1; }

OUT="ota/focus_clock-$VERSION.bin"
if [[ -f "$OUT" ]] && ! cmp -s "$BIN" "$OUT"; then
  echo "$OUT already exists with different content. Raise PROJECT_VER instead of reusing $VERSION." >&2
  exit 1
fi
cp "$BIN" "$OUT"
cat > ota/version.json <<JSON
{"version": "$VERSION", "url": "$BASE_URL/$OUT", "auto": $AUTO}
JSON
echo "Published v$VERSION ($(stat -c %s "$OUT") bytes), auto=$AUTO"
cat ota/version.json
