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
    )
)
# Note: @csv requires --raw-output parameter on jq command line
| @csv
