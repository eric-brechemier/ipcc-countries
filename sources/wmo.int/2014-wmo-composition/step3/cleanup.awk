function resetCountryRecord(){
  country=""
  values=""
  comment=""
}

function continueCountry(part){
  if ( country!="" && country!~/[a-z]-$/ ) {
    country=country " "
  }
  country=country part
}

function printCountryRecord(){
  # normalize space in country name:
  # 1. remove leading space
  # 2. remove trailing space
  # 3. replace multiple spaces with a single space
  gsub(/^ +/, "", country)
  gsub(/ +$/, "", country)
  gsub(/ +/, " ", country)

  # replace check characters with 'Y' (Yes) and 'N' (No)
  gsub(/\xef\x83\xbe/, "Y", values)
  gsub(/\xef\x82\xa8/, "N", values)

  print country values
}

# print country and values only once the end of a record is reached
# i.e. an empty line or a page break
# to make sure that all pieces of the country name have been collected
function endCountryRecord(){
  if ( country!="" && values!="" ) {
    printCountryRecord()
  }
  resetCountryRecord()
}

BEGIN {
  resetCountryRecord()
}

# print header (first 3 lines) unchanged
FNR<=3 {
  print
  next
}

# end record on an empty line
/^$/ {
  endCountryRecord()
  next
}

# replace page numbers with an empty line
# end record on a page break
/Page [0-9]+ of [0-9]+/ {
  endCountryRecord()
  print ""
  next
}

# detect official comments using keywords
/ official | request | notified | agreed | effect | decision | accession / {
  comment=comment $0 " "
  next
}

# extract country name and values of the form '3(.) ...'
/ +3\(/ {
  valuesStart=match($0,/ +3\(/)
  continueCountry( substr($0, 1, valuesStart-1) )
  values=substr($0, valuesStart)
  next
}

# extract country name and values as only a list of checkboxes
/( +\xef\x83\xbe)|( +\xef\x82\xa8)/ {
  valuesStart=match($0,/( +\xef\x83\xbe)|( +\xef\x82\xa8)/)
  continueCountry( substr($0, 1, valuesStart-1) )
  values=substr($0, valuesStart)
  next
}

# if a comment was started, continue the comment
comment!="" {
  comment=comment $0 " "
  next
}

# by default, continue the country name
{
  continueCountry($0)
}
