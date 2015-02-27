<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xhtml"
  version="1.0"
>

  <xsl:output method="text" encoding="UTF-8" />

  <xsl:variable name="NEWLINE" select="'&#xA;'" />
  <xsl:variable name="QUOTE">"</xsl:variable>
  <xsl:variable name="COMMA" select="','" />

  <xsl:template match="/">
    <!-- print headers -->
    <xsl:text>Year of Admission,Member State</xsl:text>
    <xsl:value-of select="$NEWLINE" />

    <xsl:apply-templates
      select="//xhtml:div[@id='memberlist'][1]"
    />
  </xsl:template>

  <xsl:template match="xhtml:div[@id='memberlist']">
    <xsl:apply-templates mode="csv" select="xhtml:span[@class='date']" />
  </xsl:template>

  <xsl:template mode="csv" match="xhtml:span[@class='date']">
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="$NEWLINE" />

    <xsl:apply-templates mode="csv"
      select="following-sibling::xhtml:p[@class='countries'][1]"
    >
      <xsl:with-param name="year" select="." />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template mode="csv" match="xhtml:p[@class='countries']">
    <xsl:param name="year" />
    <xsl:apply-templates mode="countries" select="text()">
      <xsl:with-param name="year" select="$year" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template mode="countries" match="text()">
    <xsl:param name="year" />
    <xsl:call-template name="next-country">
      <xsl:with-param name="year" select="$year" />
      <!-- make sure that each list of countries ends with a comma -->
      <xsl:with-param name="countries"
        select="concat(normalize-space(.),$COMMA)"
      />
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="next-country">
    <xsl:param name="year" />
    <xsl:param name="countries" />

    <xsl:variable name="country"
      select="normalize-space( substring-before($countries,$COMMA) )"
    />

    <xsl:if test="$country != ''">
      <xsl:value-of select="$year" />
      <xsl:value-of select="$COMMA" />
      <xsl:value-of select="$country" />
      <xsl:value-of select="$NEWLINE" />
    </xsl:if>

    <xsl:variable name="remaining-countries"
      select="substring-after($countries,$COMMA)"
    />
    <xsl:if test="$remaining-countries != ''">
      <!-- iteration through recursion -->
      <xsl:call-template name="next-country">
        <xsl:with-param name="year" select="$year" />
        <xsl:with-param name="countries" select="$remaining-countries" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- disable default behavior: do not copy text nodes to output -->
  <xsl:template match="text()" mode="csv" />
  <xsl:template match="text()" />

</xsl:stylesheet>
