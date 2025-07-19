#!/usr/bin/env bash
set -euo pipefail

# Racine de l'arbre TEXMF local
TEXMF_HOME="${HOME}/texmf"

# Lister toutes les libs (dossiers qui contiennent un sous-dossier tex/)
discover_libs() {
  find . -maxdepth 2 -type d -name tex \
    | sed -e 's|^\./||' -e 's|/tex$||'
}

# Installer une bibliothèque donnée
install_lib() {
  local lib="$1"
  local src_tex="${lib}/tex/"
  local src_doc="${lib}/doc/"
  local dst_tex="${TEXMF_HOME}/tex/latex/${lib}"
  local dst_doc="${TEXMF_HOME}/doc/latex/${lib}"

  if [[ ! -d "$src_tex" && ! -d "$src_doc" ]]; then
    echo "Library '$lib' does not exist or is missing tex/ and doc/."
    return 1
  fi

  echo "Installing '$lib'…"

  # Création des dossiers cibles
  [[ -d "$src_tex" ]] && mkdir -p "$dst_tex"
  [[ -d "$src_doc" ]] && mkdir -p "$dst_doc"

  # Synchronisation
  [[ -d "$src_tex" ]] && rsync -av --delete "$src_tex" "$dst_tex/"
  [[ -d "$src_doc" ]] && rsync -av --delete "$src_doc" "$dst_doc/"

  echo "'$lib' installed."
}

# --- Main ---
usage() {
  cat <<EOF
Usage: $(basename "$0") [lib1 lib2 ...]
Without arguments, installs ALL libraries found in this directory.
Each library is expected to have subfolders 'tex/' and/or 'doc/'.
EOF
  exit 1
}

# Si asked for help
if [[ "${1:-}" =~ ^(-h|--help)$ ]]; then
  usage
fi

# Décider de la liste des libs à installer
if [[ $# -ge 1 ]]; then
  libs=("$@")
else
  mapfile -t libs < <(discover_libs)
fi

if [[ ${#libs[@]} -eq 0 ]]; then
  echo "No libraries found to install."
  exit 1
fi

# Installer chacune
for lib in "${libs[@]}"; do
  install_lib "$lib"
done

# Mettre à jour la base kpathsea
echo "Updating TeX file database (mktexlsr)…"
mktexlsr >/dev/null

echo "All done! Libraries available in $TEXMF_HOME."
