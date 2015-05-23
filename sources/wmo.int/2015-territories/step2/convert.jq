# Parse list of WMO members and territories in JSON format
# and convert to CSV format

# headers
[
  "ISO Country Code",
  "English Country Name",
  "French Country Name",
  "Date of Membership",
  "CPDB URL"
]
,
(
  # records
  .countries
  | .[]
  |
    [
      .id,
      .country_name,
      .french_name,
      .wmo_membership,
      .link
    ]
)
# Note: @csv requires --raw-output parameter on jq command line
| @csv
