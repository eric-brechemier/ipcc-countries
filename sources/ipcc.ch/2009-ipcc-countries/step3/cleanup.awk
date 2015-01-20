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

# by default
{
  # print the line
  print
  # save the previous line for reference
  previousLine=$0
}
