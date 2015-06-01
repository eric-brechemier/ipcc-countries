<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/2000/svg"
  version="1.0"
>
  <!--
  Convert a list of consolidated IPCC/UN/WMO Members into an SVG
  visualization of the conditions to become an IPCC Member

  Input:
    XML without namespace, with the following structure,
    * file - root element, contains a header element
             followed with a list of record elements
    * header - element, contains a list of name elements
    * name - element, contains text
    * record - element, contains a list of field elements
    * field - element, contains text

  Output:
    SVG file for the visualization,
    with three groups of lines linked by curved areas.

    In the first group, there is one line which corresponds to UN Members.
    In the second group, two lines which correspond to WMO States and
    WMO Territories. In the third group, one line for IPCC members.

    The proportion of each line corresponds to the number of members
    in the category. Curved areas link lines together; they represent
    members of a combined category (typically members of the first group
    who also belong to the second group) and their width, from the starting
    line to the ending line, is in proportion to the number of members within.

    This visualization is inspired by Parallel Sets [1][2]. The major
    differences are that two dimensions have been merged (WMO Membership
    and State/Territory) which would be represented separately with
    Parallel Sets, and that categories for Non-Membership are not
    represented explicitly but left as negative space, without label
    and as a margin that takes the space where a line would have been drawn.
    The curved areas that start or end in one of these negative categories
    are also omitted, while areas crossing a negative category pass through.

  Reference:
    [1] Parallel Sets, a visualization technique and open source tool
    by Robert Kosara and Caroline Ziemkiewicz
    https://eagereyes.org/parallel-sets

    [2] Parallel Sets, an implementation by Jason Davies using D3.js
    http://www.jasondavies.com/parallel-sets/
  -->

  <!-- picture top margin, in user units -->
  <xsl:variable name="PICTURE_TOP_MARGIN" select="20" />

  <!-- picture bottom margin, in user units -->
  <xsl:variable name="PICTURE_BOTTOM_MARGIN" select="$PICTURE_TOP_MARGIN" />

  <!-- picture left margin, in user units -->
  <xsl:variable name="PICTURE_LEFT_MARGIN" select="30" />

  <!-- picture right margin, in user units -->
  <!--
    NOTE: it is larger than PICTURE_LEFT_MARGIN to account for
    the overflow of the text 'WMO Territories' to the right
  -->
  <xsl:variable name="PICTURE_RIGHT_MARGIN" select="80" />

  <!-- vertical margin between two groups, in user units -->
  <xsl:variable name="VERTICAL_GROUP_MARGIN" select="60" />

  <!-- total horizontal margin between groups in a line, in user units -->
  <xsl:variable name="TOTAL_HORIZONTAL_GROUP_MARGIN" select="120" />

  <!-- stroke width of lines for categories, in user units -->
  <xsl:variable name="LINE_STROKE" select="3" />

  <!-- font size for captions of categories, in user units -->
  <xsl:variable name="FONT_SIZE" select="7" />

  <!-- margin below baseline of text for captions, in user units -->
  <xsl:variable name="MARGIN_BELOW_TEXT" select="3" />

  <!-- height of the text for captions of categories, in user units -->
  <xsl:variable name="TEXT_HEIGHT" select="$FONT_SIZE + $MARGIN_BELOW_TEXT" />

  <!-- top position of the text in each group, in user units -->
  <xsl:variable name="TEXT_TOP" select="$FONT_SIZE" />

  <!-- top position of the line in each group, in user units -->
  <xsl:variable name="LINE_TOP" select="$TEXT_HEIGHT + $LINE_STROKE div 2" />

  <!-- top of the path in start group, in user units -->
  <xsl:variable name="PATH_TOP" select="$TEXT_HEIGHT + $LINE_STROKE" />

  <!-- bottom of the path in end group, in user units -->
  <xsl:variable name="PATH_BOTTOM" select="$TEXT_HEIGHT" />

  <!-- total height of a group in user units: line stroke + text -->
  <xsl:variable name="GROUP_HEIGHT" select="$LINE_STROKE + $TEXT_HEIGHT" />

  <!-- total number of groups: UN + WMO + IPCC -->
  <xsl:variable name="TOTAL_GROUPS" select="3" />

  <!--
    background of the UN flag,
    copied from PNG on UN website [1].
    Note: the exact shade is not officially specified, and the flag
    displayed on Wikipedia [2] is set in a different shade of blue.

    References:
    [1] UN Flag and Emblem
    http://www.un.org/depts/dhl/maplib/flag.htm

    [2] Flag of the United Nations
    https://en.wikipedia.org/wiki/Flag_of_the_United_Nations
  -->
  <xsl:variable name="UN_BLUE" select="'#397BCE'" />

  <!-- left position of the UN group, in user units -->
  <xsl:variable name="UN_GROUP_LEFT" select="$PICTURE_LEFT_MARGIN" />

  <!-- top position of the UN group, in user units -->
  <xsl:variable name="UN_GROUP_TOP" select="$PICTURE_TOP_MARGIN" />

  <!-- top position of the WMO groups, in user units -->
  <xsl:variable name="WMO_GROUPS_TOP"
    select="$UN_GROUP_TOP + $GROUP_HEIGHT + $VERTICAL_GROUP_MARGIN"
  />

  <!-- margin before and after WMO States group, in user units -->
  <xsl:variable name="WMO_GROUPS_MARGIN"
    select="$TOTAL_HORIZONTAL_GROUP_MARGIN div 2"
  />

  <!-- top position of the IPCC group, in user units -->
  <xsl:variable name="IPCC_GROUP_TOP"
    select="$WMO_GROUPS_TOP + $GROUP_HEIGHT + $VERTICAL_GROUP_MARGIN"
  />

  <xsl:variable name="IPCC_GROUP_LEFT" select="$PICTURE_LEFT_MARGIN" />

  <xsl:output method="xml"
    encoding="UTF-8"
    indent="yes"
  />

  <xsl:template name="title">
    <xsl:text>How does a country become a member of the </xsl:text>
    <xsl:text>Intergovernmental Panel on Climate Change (IPCC)?</xsl:text>
  </xsl:template>

  <xsl:template name="description">
    <xsl:text>Any state which is member of the United Nations (UN) </xsl:text>
    <xsl:text>or of the World Meteorological Organization (WMO) </xsl:text>
    <xsl:text>becomes de facto a member of the IPCC. </xsl:text>
    <xsl:text>UN members are all states, </xsl:text>
    <xsl:text>but WMO members can be states or territories. </xsl:text>
    <xsl:text>Only the states, not the territories, are IPCC members.</xsl:text>
  </xsl:template>

  <xsl:template name="styles">
    <xsl:text>&#xA;</xsl:text>
    <xsl:text>text {</xsl:text>
    <xsl:text>font-family: sans-serif;</xsl:text>
    <xsl:text>font-weight: bold;</xsl:text>
    <xsl:text>font-size: </xsl:text>
    <xsl:value-of select="$TEXT_HEIGHT" />
    <xsl:text>;</xsl:text>
    <xsl:text>text-anchor: middle;</xsl:text>
    <xsl:text>baseline: </xsl:text>
    <xsl:value-of select="$TEXT_HEIGHT" />
    <xsl:text>;</xsl:text>
    <xsl:text>}</xsl:text>
    <xsl:text>&#xA;</xsl:text>

    <xsl:text>line {</xsl:text>
    <xsl:text>stroke-width: </xsl:text>
    <xsl:value-of select="$LINE_STROKE" />
    <xsl:text>;</xsl:text>
    <xsl:text>stroke: black;</xsl:text>
    <xsl:text>stroke-linecap: round;</xsl:text>
    <xsl:text>}</xsl:text>
    <xsl:text>&#xA;</xsl:text>

    <xsl:text>path {</xsl:text>
    <xsl:text>fill: </xsl:text>
    <xsl:value-of select="$UN_BLUE" />
    <xsl:text>;</xsl:text>
    <xsl:text>}</xsl:text>
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="file">
    <xsl:variable name="totalRecords" select="count(record)" />
    <xsl:variable name="width"
      select="
          $PICTURE_LEFT_MARGIN
        + $totalRecords
        + $TOTAL_HORIZONTAL_GROUP_MARGIN
        + $PICTURE_RIGHT_MARGIN
      "
    />
    <xsl:variable name="height"
      select="
          $PICTURE_TOP_MARGIN
        + $TOTAL_GROUPS * $GROUP_HEIGHT
        + ($TOTAL_GROUPS - 1) * $VERTICAL_GROUP_MARGIN
        + $PICTURE_BOTTOM_MARGIN
      "
    />

    <svg viewBox="0 0 {$width} {$height}">
      <title>
        <xsl:call-template name="title" />
      </title>
      <desc>
        <xsl:call-template name="description" />
      </desc>
      <defs>
        <style type="text/css">
          <xsl:call-template name="styles" />
        </style>
      </defs>
      <xsl:call-template name="un-to-ipcc" />
      <xsl:call-template name="un-to-wmo" />
      <xsl:call-template name="wmo-to-ipcc" />

      <xsl:call-template name="un-members" />
      <xsl:call-template name="wmo-members" />
      <xsl:call-template name="ipcc-members" />
    </svg>
  </xsl:template>

  <xsl:variable name="FIELD_IPCC" select="1" />
  <xsl:variable name="FIELD_UN" select="2" />
  <xsl:variable name="FIELD_WMO" select="3" />

  <xsl:template name="un-members">
    <xsl:variable name="totalUnMembers"
      select="count( record[ field[$FIELD_UN] = 'UN' ] )"
    />
    <g id="UN-members"
      transform="translate({ $UN_GROUP_LEFT },{ $UN_GROUP_TOP })">
      <title>
        <xsl:text>UN Members: </xsl:text>
        <xsl:value-of select="$totalUnMembers" />
        <xsl:text> states.</xsl:text>
      </title>
      <text
        x="{$totalUnMembers div 2}"
        y="{$TEXT_TOP}"
      >
        <xsl:text>UN</xsl:text>
      </text>
      <line
        x1="0"
        x2="{$totalUnMembers}"
        y1="{$LINE_TOP}"
        y2="{$LINE_TOP}"
      />
    </g>
  </xsl:template>

  <xsl:template name="wmo-members">
    <xsl:variable name="totalWmoStates"
      select="count( record[ field[$FIELD_WMO] = 'WMO State' ] )"
    />
    <xsl:variable name="totalWmoTerritories"
      select="count( record[ field[$FIELD_WMO] = 'WMO Territory' ] )"
    />
    <xsl:variable name="totalNotWmoStates"
      select="count( record[ field[$FIELD_WMO] = 'NOT WMO' ] )"
    />
    <xsl:variable name="leftWmoStates"
      select="$PICTURE_LEFT_MARGIN + $totalNotWmoStates + $WMO_GROUPS_MARGIN"
    />
    <g id="WMO-states"
      transform="translate({ $leftWmoStates },{ $WMO_GROUPS_TOP })"
    >
      <title>
        <xsl:text>WMO States: </xsl:text>
        <xsl:value-of select="$totalWmoStates" />
        <xsl:text> states.</xsl:text>
      </title>
      <text
        x="{$totalWmoStates div 2}"
        y="{$FONT_SIZE}"
      >
        <xsl:text>WMO States</xsl:text>
      </text>
      <line
        x1="0"
        x2="{$totalWmoStates}"
        y1="{$LINE_TOP}"
        y2="{$LINE_TOP}"
      />
    </g>
    <xsl:variable name="leftWmoTerritories"
      select="$leftWmoStates + $totalWmoStates +  $WMO_GROUPS_MARGIN"
    />
    <g id="WMO-territories"
      transform="translate({ $leftWmoTerritories },{ $WMO_GROUPS_TOP })"
    >
      <title>
        <xsl:text>WMO Territories: </xsl:text>
        <xsl:value-of select="$totalWmoTerritories" />
        <xsl:text> territories.</xsl:text>
      </title>
      <text
        x="{$totalWmoTerritories div 2}"
        y="{$FONT_SIZE}"
      >
        <xsl:text>WMO Territories</xsl:text>
      </text>
      <line
        x1="0"
        x2="{$totalWmoTerritories}"
        y1="{$LINE_TOP}"
        y2="{$LINE_TOP}"
      />
    </g>
  </xsl:template>

  <xsl:template name="ipcc-members">
    <xsl:variable name="totalIpccMembers"
      select="count( record[ field[$FIELD_IPCC] = 'IPCC' ] )"
    />
    <g id="IPCC-members"
      transform="translate({ $IPCC_GROUP_LEFT },{ $IPCC_GROUP_TOP })"
    >
      <title>
        <xsl:text>IPCC Members: </xsl:text>
        <xsl:value-of select="$totalIpccMembers" />
        <xsl:text> states.</xsl:text>
      </title>
      <text
        x="{$totalIpccMembers div 2}"
        y="{$TEXT_TOP}"
      >
        <xsl:text>IPCC</xsl:text>
      </text>
      <line
        x1="0"
        x2="{$totalIpccMembers}"
        y1="{$LINE_TOP}"
        y2="{$LINE_TOP}"
      />
    </g>
  </xsl:template>

  <xsl:template name="un-to-ipcc">
    <xsl:variable name="totalUnNotWmoMembers"
      select="count(
        record[
              field[$FIELD_UN] = 'UN'
          and field[$FIELD_WMO] = 'NOT WMO'
        ]
      )"
    />
    <path>
      <xsl:attribute name="d">
        <xsl:text>M </xsl:text>
        <xsl:value-of select="$UN_GROUP_LEFT + $totalUnNotWmoMembers" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="$UN_GROUP_TOP + $PATH_TOP" />

        <xsl:text>H </xsl:text>
        <xsl:value-of select="$UN_GROUP_LEFT" />

        <xsl:text>L </xsl:text>
        <xsl:value-of select="$IPCC_GROUP_LEFT" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="$IPCC_GROUP_TOP + $PATH_BOTTOM" />

        <xsl:text>h </xsl:text>
        <xsl:value-of select="$totalUnNotWmoMembers" />

        <xsl:text>Z</xsl:text>
      </xsl:attribute>
    </path>
  </xsl:template>

  <xsl:template name="un-to-wmo">
    <xsl:variable name="totalUnMembers"
      select="count( record[ field[$FIELD_UN] = 'UN' ] )"
    />
    <xsl:variable name="totalUnAndWmoStates"
      select="count(
        record[
              field[$FIELD_UN] = 'UN'
          and field[$FIELD_WMO] = 'WMO State'
        ]
      )"
    />
    <xsl:variable name="totalNotWmoStates"
      select="count( record[ field[$FIELD_WMO] = 'NOT WMO' ] )"
    />
    <xsl:variable name="leftWmoStates"
      select="$PICTURE_LEFT_MARGIN + $totalNotWmoStates + $WMO_GROUPS_MARGIN"
    />
    <path>
      <xsl:attribute name="d">
        <xsl:text>M </xsl:text>
        <xsl:value-of select="$UN_GROUP_LEFT + $totalUnMembers" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="$UN_GROUP_TOP + $PATH_TOP" />

        <xsl:text>h -</xsl:text>
        <xsl:value-of select="$totalUnAndWmoStates" />

        <xsl:text>L </xsl:text>
        <xsl:value-of select="$leftWmoStates" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="$WMO_GROUPS_TOP + $PATH_BOTTOM" />

        <xsl:text>h </xsl:text>
        <xsl:value-of select="$totalUnAndWmoStates" />

        <xsl:text>Z</xsl:text>
      </xsl:attribute>
    </path>
  </xsl:template>

  <xsl:template name="wmo-to-ipcc">
    <xsl:variable name="totalWmoStates"
      select="count( record[ field[$FIELD_WMO] = 'WMO State' ] )"
    />
    <xsl:variable name="totalNotWmoStates"
      select="count( record[ field[$FIELD_WMO] = 'NOT WMO' ] )"
    />
    <xsl:variable name="leftWmoStates"
      select="$PICTURE_LEFT_MARGIN + $totalNotWmoStates + $WMO_GROUPS_MARGIN"
    />
    <path>
      <xsl:attribute name="d">
        <xsl:text>M </xsl:text>
        <xsl:value-of select="$leftWmoStates + $totalWmoStates" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="$WMO_GROUPS_TOP + $PATH_TOP" />

        <xsl:text>H</xsl:text>
        <xsl:value-of select="$leftWmoStates" />

        <xsl:text>L </xsl:text>
        <xsl:value-of select="$IPCC_GROUP_LEFT" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="$IPCC_GROUP_TOP + $PATH_BOTTOM" />

        <xsl:text>h </xsl:text>
        <xsl:value-of select="$totalWmoStates" />

        <xsl:text>Z</xsl:text>
      </xsl:attribute>
    </path>
  </xsl:template>

</xsl:stylesheet>
