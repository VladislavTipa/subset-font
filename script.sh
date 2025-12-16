#!/usr/bin/env bash
set -euo pipefail

# Правильный парсинг аргументов (всегда 3 параметра)
INPUT_FONT="${1:-}"
OUTPUT_DIR="${2:-}"
HTML_FILE="${3:-}"

# Проверки
[[ -z "$INPUT_FONT" ]] && { echo "Usage: $0 <font.ttf> <out/> <file.html>"; exit 1; }
[[ -z "$OUTPUT_DIR" ]] && { echo "Usage: $0 <font.ttf> <out/> <file.html>"; exit 1; }
[[ -z "$HTML_FILE" ]] && { echo "Usage: $0 <font.ttf> <out/> <file.html>"; exit 1; }

NAME=$(basename "$INPUT_FONT" .ttf | sed 's/\.[^.]*$//')-subset

command -v pyftsubset >/dev/null 2>&1 || { echo "Install: pip install fonttools brotli"; exit 1; }
[[ ! -f "$INPUT_FONT" ]] && { echo "No font: $INPUT_FONT"; exit 1; }
[[ ! -f "$HTML_FILE" ]] && { echo "No HTML: $HTML_FILE"; exit 1; }

mkdir -p "$OUTPUT_DIR"

# Извлекаем текст из HTML
TEXT=$(cat "$HTML_FILE" | \
  sed -e 's/<script[^>]*>.*<\/script>//gI' \
      -e 's/<style[^>]*>.*<\/style>//gI' \
      -e 's/<!--.*-->//g' \
      -e 's/<[^>]*>//g' \
      -e 's/&nbsp;/ /g' \
      -e 's/&[a-zA-Z0-9#]\+;/ /g' | \
  tr -d '\n\r\t ' | \
  grep -o '[[:print:]]' | \
  sort | uniq | tr -d '\n')

[[ -z "$TEXT" ]] && TEXT="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 "

pyftsubset "$INPUT_FONT" \
  --output-file="$OUTPUT_DIR/$NAME.woff2" \
  --flavor=woff2 \
  --text="$TEXT"

echo "✅ Created: $OUTPUT_DIR/$NAME.woff2 ($(du -h "$OUTPUT_DIR/$NAME.woff2" | cut -f1))"
echo "📝 Used ${#TEXT} unique chars"
