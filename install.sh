#!/usr/bin/bash

set -e
git clone git@github.com:MatthieuPerrin/Latex-sty.git ~/Latex-sty
rsync -av ~/Latex-sty/texmf/ ~/texmf/
mktexlsr ~/texmf
echo "Styles installed. You can now use \\usepackage{...}."
