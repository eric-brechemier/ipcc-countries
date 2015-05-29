# Parse JSON data returned by Special:Entity API of Wikidata
# and convert it to CSV format

# headers
[
  "Entity",
  "Group",
  "Value Name",
  "Value Type",
  "Value",
  "Rank",
  "Start Time",
  "End Time"
]
,
(
  # records
  .entities
  | .[]
  | [
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      ""
    ] as $empty_record
  | .id as $entity
  | (
      .aliases
      | .[]
      | .[]
      | [
          $entity,
          "alias",
          "language",
          .language,
          .value,
          "",
          "",
          ""
        ]
    ),
    $empty_record,
    (
      .descriptions
      | .[]
      | [
          $entity,
          "description",
          "language",
          .language,
          .value,
          "",
          "",
          ""
        ]
    ),
    $empty_record,
    (
      .labels
      | .[]
      | [
          $entity,
          "label",
          "language",
          .language,
          .value,
          "",
          "",
          ""
        ]
    ),
    $empty_record,
    (
      .claims
      | .[]
      | .[]
      | .rank as $rank
      | .qualifiers.P580[0].datavalue.value.time as $start_time
      | .qualifiers.P582[0].datavalue.value.time as $end_time
      | .mainsnak
      | .property as $value_name
      | if .datatype == "globe-coordinate"
        then
          .datavalue.value
          | { latitude, longitude, altitude }
          | to_entries
          | .[]
          | .key as $value_type
          | .value
          | values
          | [
              $entity,
              "claim",
              $value_name,
              $value_type,
              .,
              $rank,
              $start_time,
              $end_time
            ]
        else
          .datatype as $value_type
          | (
              .datavalue.value
              | (
                     scalars
                  // ."numeric-id"
                  // .amount
                  // .text
                  // .time
                )
            )
          | [
              $entity,
              "claim",
              $value_name,
              $value_type,
              .,
              $rank,
              $start_time,
              $end_time
            ]
      end
    ),
    $empty_record,
    (
      .sitelinks
      | .[]
      | [
          $entity,
          "sitelink",
          "site",
          .site,
          .title,
          "",
          "",
          ""
        ]
    )
)
# Note: @csv requires --raw-output parameter on jq command line
| @csv
