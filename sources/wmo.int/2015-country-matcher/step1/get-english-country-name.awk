# Get the English Country Name on each line,
# separated from the French Country Name by " - "

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

/ - / {
  print substringBefore($0," - ")
  next
}

# default: skip the line
{
  print "Unexpected format on line: '" $0 "'" > "/dev/stderr"
}
