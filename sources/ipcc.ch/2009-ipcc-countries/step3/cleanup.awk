BEGIN {
  started=0
}

# first line of interest
/^AFRICA \(Region I\)/ { started=1 }

# skip lines before the first line of interest
started==0 { next }

# skip lines starting with a parenthesis (number of countries in the region)
/^\(/ { next }

# skip lines starting with an underscore (horizontal rule)
/^_/ { next }

# skip lines starting with a number (page numbers)
/^[0-9]/ { next }

# skip duplicate empty lines
/^$/ && previousLine=="" { next }

# skip line with only a control character (found at end of file)
/^\014$/ { next }

# remove control character found at the start of some lines
/^\014/ {
  $0=substr($0, 2)
}

# by default
{
  # print the line
  print
  # save the previous line for reference
  previousLine=$0
}
