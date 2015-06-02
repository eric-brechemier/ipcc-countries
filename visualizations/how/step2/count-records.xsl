<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/2000/svg"
  version="1.0"
>
  <!--
  Count number of records for different combinations of IPCC/UN/WMO membership

  All the utility functions defined here are expected to be called in the
  context of the top level element of the document (file).

  Input:
    XML without namespace, with the following structure,
    * file - root element, contains a header element
             followed with a list of record elements
    * header - element, contains a list of name elements
    * name - element, contains text
    * record - element, contains a list of field elements
    * field - element, contains text
  -->

  <xsl:template name="total-records">
    <xsl:value-of select="count(record)" />
  </xsl:template>

  <xsl:variable name="FIELD_IPCC" select="1" />
  <xsl:variable name="FIELD_UN" select="2" />
  <xsl:variable name="FIELD_WMO" select="3" />

  <xsl:template name="total-un-members">
    <xsl:value-of
      select="count( record[ field[$FIELD_UN] = 'UN' ] )"
    />
  </xsl:template>

  <xsl:template name="total-wmo-states">
    <xsl:value-of
      select="count( record[ field[$FIELD_WMO] = 'WMO State' ] )"
    />
  </xsl:template>

  <xsl:template name="total-wmo-territories">
    <xsl:value-of
      select="count( record[ field[$FIELD_WMO] = 'WMO Territory' ] )"
    />
  </xsl:template>

  <xsl:template name="total-ipcc-members">
    <xsl:value-of
      select="count( record[ field[$FIELD_IPCC] = 'IPCC' ] )"
    />
  </xsl:template>

  <xsl:template name="total-wmo-states-not-un">
    <xsl:value-of
      select="count(
        record[
              field[$FIELD_WMO] = 'WMO State'
          and field[$FIELD_UN] = 'NOT UN'
        ]
      )"
    />
  </xsl:template>

  <xsl:template name="total-un-states-not-wmo">
    <xsl:value-of
      select="count(
        record[
              field[$FIELD_UN] = 'UN'
          and field[$FIELD_WMO] = 'NOT WMO'
        ]
      )"
    />
  </xsl:template>

  <xsl:template name="total-states-both-wmo-and-un">
    <xsl:value-of
      select="count(
        record[
              field[$FIELD_UN] = 'UN'
          and field[$FIELD_WMO] = 'WMO State'
        ]
      )"
    />
  </xsl:template>

</xsl:stylesheet>
