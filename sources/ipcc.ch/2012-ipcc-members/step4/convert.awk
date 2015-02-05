BEGIN {
  region=""
  separator=","
  quote="\""

  # print headers
  print "WMO Region (Region Number),Country"
}

# REGION: escape comma found in region name
/, .+ \(Region / {
  region=quote $0 quote
  next
}

# REGION
/\(Region / {
  region=$0
  next
}

# EMPTY LINE: insert empty records to separate columns
/^$/ {
  print "" separator ""
  next
}

# COUNTRY: escape comma found in country name
/,/ {
  print region separator quote $0 quote
  next
}

# COUNTRY
{
  print region separator $0
}
