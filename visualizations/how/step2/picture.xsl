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

  <!-- total margin to separate groups of lines horizontally, in user units -->
  <xsl:variable name="TOTAL_HORIZONTAL_GROUP_MARGIN" select="24" />

  <!-- vertical margin between two groups, in user units -->
  <xsl:variable name="VERTICAL_GROUP_MARGIN" select="60" />

  <!-- stroke width of lines for categories, in user units -->
  <xsl:variable name="LINE_STROKE" select="3" />

  <!-- height of the text for captions of categories, in user units -->
  <xsl:variable name="TEXT_HEIGHT" select="7" />

  <!-- total height of a group in user units: line stroke + text -->
  <xsl:variable name="GROUP_HEIGHT" select="$LINE_STROKE + $TEXT_HEIGHT" />

  <!-- total number of groups: UN + WMO + IPCC -->
  <xsl:variable name="TOTAL_GROUPS" select="3" />

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
    <xsl:text>UN embers are all states, </xsl:text>
    <xsl:text>but WMO members can be states or territories. </xsl:text>
    <xsl:text>Only the states, not the territories, are IPCC members.</xsl:text>
  </xsl:template>

  <xsl:template name="styles">

  </xsl:template>

  <xsl:template match="file">
    <xsl:variable name="totalRecords" select="count(record)" />
    <xsl:variable name="width"
      select="$totalRecords + $TOTAL_HORIZONTAL_GROUP_MARGIN"
    />
    <xsl:variable name="height"
      select="
          $TOTAL_GROUPS * $GROUP_HEIGHT
        + ($TOTAL_GROUPS - 1) * $VERTICAL_GROUP_MARGIN"
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
    </svg>
  </xsl:template>

</xsl:stylesheet>
