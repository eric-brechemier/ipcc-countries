#!/bin/sh
cd "$(dirname "$0")"

page='Flags_of_extinct_states'
url="https://commons.wikimedia.org/wiki/$page"
file="$page.html"

wget -O "$file" "$url"

cat << EOF > ../url.html
<meta http-equiv="refresh" content="0;
  url=$url
"/>
EOF
