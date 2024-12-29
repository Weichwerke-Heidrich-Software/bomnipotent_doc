#!/bin/bash

set -e

mkdir -p static
mkdir -p static/webfonts
wget -P static/webfonts https://github.com/CatharsisFonts/Cormorant/raw/refs/heads/master/fonts/webfonts/Cormorant-Regular.woff2
