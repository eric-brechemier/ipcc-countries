# Convert a stream of lines to XML
#
# Usage:
#   awk -f lines2xml.awk < input.txt > output.xml
#
# Input:
#   lines of text encoded in UTF-8
#
# Output:
#   xml file with the following structure:
#   <lines>
#     <line>...</line>
#     ...
#   </lines>
#
#   In the value for each line,
#   the end of line characters carriage return and line feed are removed
#   and any occurrence of '<' is replaced with the XML entity '&lt;'.
BEGIN {
  print "<lines>"
}

# for each line
{
  gsub("<", "\\&lt;")
  gsub("\r", "")
  line = "<line>" $0 "</line>"
  print line
}

END {
  print "</lines>"
}
