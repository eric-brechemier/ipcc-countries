# Trim given string (remove whitespace on both ends)
#
# Parameter:
#   string - string, the string to trim
#
# Returns:
#   string, a copy of the given string with all the whitespace characters
#   found at the start and end of the string removed.
#
# Note:
#   The original string is left unchanged.
#
function trim(string) {
  return gensub(/^[[:space:]]+|[[:space:]]+$/, "", "g", string)
}

# Extract the start of a string before given substring
#
# Parameters:
#   string - string, the string from which to extract the start
#   substring - string, the substring to look for
#
# Returns:
#   string, the start of the string before first occurrence of given substring,
#   or the empty string when the substring is not found in the string.
#
# Note:
#   When the substring is the empty string, the empty string is returned.
#
function substringBefore(string, substring,    position) {
  position = index(string, substring)
  if ( position == 0 ) {
    return ""
  }
  return substr(string, 1, position-1)
}

# Extract the end of a string after given substring
#
# Parameters:
#   string - string, the string from which to extract the end
#   substring - string, the substring to look for
#
# Returns:
#   string, the end of the string after the first occurrence of given substring
#   or the empty string when the substring is not found in the string.
#
# Note:
#   When the substring is the empty string, the whole string is returned.
#
function substringAfter(string, substring,    position) {
  position = index(string, substring)
  if ( position == 0 ) {
    return ""
  }
  return substr(string, position + length(substring))
}

# Check whether a substring is found in given string
#
# Parameters:
#   string - string, the string where to look
#   substring - string, the substring to look for
#
# Returns:
#   boolean, true when the substring is found anywhere in the given string,
#   false otherwise
#
function contains(string, substring) {
  return index(string, substring)
}

# Replace every occurrence of a substring found in a string with a replacement
#
# Parameters:
#   string - string, the string to search for substrings to replace
#   substring - string, a regular expression, written as a string,
#               which matches the substring to replace
#   replacement - string, the replacement for each substring found
#
# Returns:
#   string, a copy of the given string with every occurrence of the
#   matching substring replaced with given replacement
#
# Note:
#   The original string is left unchanged.
#
function replace(string, substring, replacement) {
  return gensub(substring, replacement, "g", string)
}

# Escape a string as a Comma-Separated Value (CSV) field
#
# Parameter:
#   string - string, the string to escape
#
# Returns:
#   string, the same string unchanged if it contains no comma,
#   otherwise the string surrounded with quotes with quotes doubled within
function csvField(string,    separator, quote) {
  separator=","
  quote="\""
  if ( !contains(string,separator) ){
    return string
  }
  return quote replace(string, quote, quote quote) quote
}

BEGIN {
  separator=","
  quote="\""

  emptyRecord= \
    separator \
    separator \
    separator \
    separator \
    separator \
    separator \
    separator \
    separator \
    separator \
    separator \
    separator \
    separator \
    separator \
    separator \
    separator

  # print headers
  print \
    csvField("WMO Member Name in English - French") \
    separator \
    csvField("Date of Membership") \
    separator \
    csvField("Regional Association I (Africa)") \
    separator \
    csvField("Regional Association II (Asia)") \
    separator \
    csvField("Regional Association III (South America)") \
    separator \
    csvField("Regional Association IV (North America, Central America and the Caribbean)") \
    separator \
    csvField("Regional Association V (South-West Pacific)") \
    separator \
    csvField("Regional Association VI (Europe)") \
    separator \
    csvField("Commission for Basic Systems (CBS)") \
    separator \
    csvField("Commission for Instruments and Methods of Observation (CIMO)") \
    separator \
    csvField("Commission for Atmospheric Sciences (CAS)") \
    separator \
    csvField("Commission for Aeronautical Meteorology (CAeM)") \
    separator \
    csvField("Commission for Agricultural Meteorology (CAgM)") \
    separator \
    csvField( \
      "Joint WMO-IOC Technical Commission " \
      "for Oceanography and Marine Meteorology (JCOMM)" \
    ) \
    separator \
    csvField("Commission for Hydrology (CHy)") \
    separator \
    csvField("Commission for Climatology (CCl)")
}

# skip header in text format (first 3 lines)
FNR<=3 {
  next
}

# convert empty line to an empty record
/^$/ {
  print emptyRecord
  next
}

# by default
{
  country=substringBefore($0,"  ")
  remain=trim(substringAfter($0,country))

  if ( remain ~ /^3\(.) ..\/..\/....  / ) {
    date=\
      substringAfter( \
       substringBefore(remain,"  "), \
       ") " \
    )
    remain=trim(substringAfter(remain,date))
  } else {
    date=""
  }

  yesNoFields=replace(remain," +",separator)
  remain=""

  print \
    csvField(country) \
    separator \
    csvField(date) \
    separator \
    yesNoFields
}
