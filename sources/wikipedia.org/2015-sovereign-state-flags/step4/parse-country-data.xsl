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

  <xsl:variable name="EMPTY_RECORD"
    select="concat($COMMA,$COMMA,$NEWLINE)"
  />

  <xsl:template match="/">
    <!-- print headers -->
    <xsl:text>Country</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Property Name</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Property Value</xsl:text>
    <xsl:value-of select="$NEWLINE" />

    <xsl:variable
      name="country"
      select="
        /xhtml:html
        /xhtml:body
        /xhtml:div[@id='content'][1]
        /xhtml:h1[1]
      "
    />
    <xsl:message>
      <xsl:text>Country: </xsl:text>
      <xsl:value-of select="$country" />
    </xsl:message>
    <xsl:apply-templates
      select="
        /xhtml:html
        /xhtml:body
        /xhtml:div[@id='content'][1]
        /xhtml:div[@id='bodyContent'][1]
        /xhtml:div[@id='mw-content-text'][1]
        /xhtml:table[@class='infobox geography vcard'][1]
        /xhtml:tr
      "
    >
      <xsl:with-param name="country" select="$country" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="xhtml:tr[ count(xhtml:th)=1 and count(xhtml:td)=1 ]">
    <xsl:param name="country" />
    <xsl:variable name="propertyName" select="xhtml:th[1]" />
    <xsl:variable name="propertyValue" select="xhtml:td[1]" />
    <xsl:message>
      <xsl:text>Name: </xsl:text>
      <xsl:value-of select="$propertyName" />
    </xsl:message>
    <xsl:message>
      <xsl:text>Value: </xsl:text>
      <xsl:value-of select="$propertyValue" />
    </xsl:message>

    <xsl:value-of select="$country" />
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="$propertyName" />
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="$propertyValue" />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

  <xsl:template match="xhtml:tr">
    <xsl:param name="country" />
    <xsl:message>
      <xsl:text>Property skipped (not recognized):</xsl:text>
      <xsl:copy-of select="." />
    </xsl:message>
  </xsl:template>

</xsl:stylesheet>
