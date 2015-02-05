BEGIN {
  newline="\n"

  # whether the first line of interest has been reached
  started=0

  # whether the first line of the column to reorder has been reached
  # and the end of the column (empty line) has not bean reached yet
  buffering=0

  # whether a column has been buffered to be reordered
  # i.e. inserted after the current column
  buffered=0

  # buffered lines of output
  lines=""
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

# group a line which ends with '&' with the next line
/&$/ {
  previousLine=$0
  next
}

# group previous line, ending with &, with this one, adding space as separator
previousLine ~ /&$/ {
  $0=previousLine " " $0
}

/^$/ && buffered==1 {
  print lines
  buffered=0
}

/^$/ && buffering==1 {
  buffering=0
  buffered=1
  next
}

buffering==1 {
  lines=lines newline $0
  next
}

# reorder columns in 'SOUTH-WEST PACIFIC'
/^SOUTH-WEST PACIFIC/ {
  buffering=1
}

# by default
{
  # print the line
  print
  # save the previous line for reference
  previousLine=$0
}
