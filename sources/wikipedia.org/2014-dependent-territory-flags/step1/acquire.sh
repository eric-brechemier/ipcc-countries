#!/bin/sh
cd $(dirname "$0")

page='Gallery_of_flags_of_dependent_territories'
url="https://en.wikipedia.org/wiki/$page"
file="$page.html"

wget -O "$file" "$url"

cat << EOF > ../url.html
<meta http-equiv="refresh" content="0;
  url=$url
"/>
EOF
