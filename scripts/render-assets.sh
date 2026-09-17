#!/usr/bin/env bash
#
# Regenera os PNGs de assets/ a partir dos SVGs.
#
#   assets/icon.svg    -> assets/icon-{512,128,32}.png
#   assets/preview.svg -> assets/preview.png
#
# O macOS não traz rasterizador de SVG (`sips` não lê SVG), então o render sai
# pelo Chrome headless. Três particularidades justificam o caminho tortuoso:
#
#   1. `--window-size` do Chrome headless não garante altura exata de viewport,
#      então renderizar no tamanho final corta a base da imagem.
#   2. O corte do `sips` é sempre central e ignora `--cropOffset`. Por isso os
#      wrappers HTML centralizam a imagem numa caixa de altura fixa em PIXELS
#      (não `100%`): assim imagem e screenshot compartilham o mesmo centro e o
#      corte central é exato mesmo se o viewport vier menor que o pedido.
#   3. O Chrome headless não encerra sozinho depois de escrever o screenshot.
#      Rodar em primeiro plano travaria o script para sempre, então ele vai para
#      segundo plano, o arquivo de saída é aguardado por polling e o processo é
#      morto em seguida.
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

if [[ ! -x "$CHROME" ]]; then
  echo "Google Chrome não encontrado em $CHROME" >&2
  exit 1
fi

# shoot <wrapper.html> <window_w> <window_h> <saida.png>
shoot() {
  local wrapper="$1" win_w="$2" win_h="$3" out="$4"
  local profile
  profile="$(mktemp -d -t polar-dark-chrome-XXXXXX)"

  rm -f "$out"

  "$CHROME" \
    --headless \
    --disable-gpu \
    --hide-scrollbars \
    --user-data-dir="$profile" \
    --default-background-color=00000000 \
    --window-size="${win_w},${win_h}" \
    --screenshot="$out" \
    "file://$ROOT/scripts/$wrapper" >/dev/null 2>&1 &
  local pid=$!

  # espera o screenshot aparecer, com teto de ~20s
  local waited=0
  while [[ ! -s "$out" && $waited -lt 80 ]]; do
    sleep 0.25
    waited=$((waited + 1))
  done
  sleep 0.5

  kill "$pid" >/dev/null 2>&1 || true
  wait "$pid" >/dev/null 2>&1 || true
  rm -rf "$profile"

  if [[ ! -s "$out" ]]; then
    echo "render falhou: $out vazio ($wrapper)" >&2
    exit 1
  fi
}

raw_icon="$(mktemp -t polar-dark-icon-XXXXXX).png"
raw_prev="$(mktemp -t polar-dark-prev-XXXXXX).png"

shoot "icon-render.html" 760 760 "$raw_icon"
sips -c 512 512 "$raw_icon" --out "$ROOT/assets/icon-512.png" >/dev/null
sips -Z 128 "$ROOT/assets/icon-512.png" --out "$ROOT/assets/icon-128.png" >/dev/null
sips -Z 32  "$ROOT/assets/icon-512.png" --out "$ROOT/assets/icon-32.png"  >/dev/null

shoot "preview-render.html" 900 600 "$raw_prev"
sips -c 430 760 "$raw_prev" --out "$ROOT/assets/preview.png" >/dev/null

rm -f "$raw_icon" "$raw_prev"
echo "assets/icon-{512,128,32}.png e assets/preview.png atualizados"
