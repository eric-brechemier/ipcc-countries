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
    <xsl:text>Country Name To Identify,</xsl:text>
    <xsl:text>Matching Country Name,</xsl:text>
    <xsl:text>ISO Country Code,</xsl:text>
    <xsl:text>Matching Method</xsl:text>
    <xsl:value-of select="$NEWLINE" />

    <xsl:apply-templates
      select="//xhtml:table[1]"
    />
  </xsl:template>

  <xsl:template match="xhtml:table">
    <xsl:apply-templates mode="csv" />
  </xsl:template>

  <!-- skip header row -->
  <xsl:template mode="csv" match="xhtml:tr[xhtml:th]" />

  <xsl:template mode="csv" match="xhtml:tr">
    <xsl:for-each select="xhtml:td">
      <xsl:apply-templates mode="csv" select="." />
      <xsl:choose>
        <xsl:when test="following-sibling::xhtml:td">
          <xsl:value-of select="$COMMA" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$NEWLINE" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template mode="csv" match="xhtml:td[ contains(.,',') ]">
    <xsl:value-of select="$QUOTE" />
    <!-- Note: this particular input does not contain any quote to escape -->
    <xsl:value-of select="." />
    <xsl:value-of select="$QUOTE" />
  </xsl:template>

  <xsl:template mode="csv" match="xhtml:td">
    <xsl:value-of select="." />
  </xsl:template>

  <!-- disable default behavior: do not copy text nodes to output -->
  <xsl:template match="text()" mode="csv" />
  <xsl:template match="text()" />

</xsl:stylesheet>
