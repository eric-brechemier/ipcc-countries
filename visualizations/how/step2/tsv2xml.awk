# Convert a file from TSV (Tab Separated Values)
# to XML with the following structure:
# <file>
#   <header> <!-- first record -->
#     <name>...</name>
#     ...
#   </header>
#   <record>
#     <field>...</field>
#     ...
#   </record>
#   ...
# </file>
#
# Usage: awk -f tsv2xml.awk < data.tsv > data.xml
#
# Note: CSV can be converted to TSV using -T flag of csvformat, from csvkit.

BEGIN {
  FS="\t"
  print "<file>"
}

NR==1 {
  recordName="header"
  fieldName="name"
}

NR>1 {
  recordName="record"
  fieldName="field"
}

{
  print "<" recordName ">"
  for (field=1; field<=NF; field++) {
    gsub("\\&","\\&amp;",$field)
    gsub("<","\\&lt;",$field)
    print "<" fieldName ">" $field "</" fieldName ">"
  }
  print "</" recordName ">"
}

END {
  print "</file>"
}
