#!/bin/sh
# requires xsltproc
# requires inkscape (0.48.3.1)
# uses optipng (0.6.4) if available

cd "$(dirname "$0")"

. ./sprite.properties.sh

echo 'List SVG file images as XML'
ls ../../../database/data/*.svg |
awk -f lines2xml.awk \
> flags-list.xml

echo 'Combine flags of current IPCC members into a single SVG file'
xsltproc \
  --param MAX_WIDTH "$sprite_max_width" \
  --param WIDTH "$sprite_width" \
  --param HEIGHT "$sprite_height" \
  --param MARGIN "$sprite_margin" \
  --novalid combine.xsl flags-list.xml \
> flags.svg

echo 'Convert combined SVG to PNG'
inkscape --export-png=flags.png --file=flags.svg

if command -v optipng
then
  echo 'Optimize PNG'
  optipng flags.png
fi

echo 'Generate CSS classes for the positions of flags in the image'
xsltproc \
  --stringparam IMAGE_PATH "$sprite_path" \
  --param MAX_WIDTH "$sprite_max_width" \
  --param WIDTH "$sprite_width" \
  --param HEIGHT "$sprite_height" \
  --param MARGIN "$sprite_margin" \
  --novalid css-classes.xsl flags-list.xml \
> flags.css
