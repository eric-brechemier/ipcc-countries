#!/bin/sh
cd "$(dirname "$0")"

page='Gallery_of_sovereign_state_flags'
url="https://en.wikipedia.org/wiki/$page"
file="$page.html"

wget -O "$file" "$url"

cat << EOF > ../url.html
<meta http-equiv="refresh" content="0;
  url=$url
"/>
EOF
