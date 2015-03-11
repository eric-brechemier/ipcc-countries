<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
>

  <xsl:output method="text" encoding="UTF-8" />

  <xsl:variable name="NEWLINE" select="'&#xA;'" />
  <xsl:variable name="QUOTE">"</xsl:variable>
  <xsl:variable name="COMMA" select="','" />

  <xsl:template match="/">
    <!-- print headers -->
    <xsl:text>Alpha-2 ISO Country Code</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Numeric ISO Country Code</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Alpha-3 ISO Country Code</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>FIPS 10</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Internet TLD</xsl:text>
    <xsl:value-of select="$NEWLINE" />

    <xsl:apply-templates
      select="/supplementalData/codeMappings/territoryCodes"
    />
  </xsl:template>

  <xsl:template match="territoryCodes">
    <xsl:apply-templates mode="csv" select="@type" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="@numeric" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="@alpha3" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="@fips10" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="@internet" />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

  <xsl:template mode="csv" match="node()[ contains(.,',') ]">
    <xsl:value-of select="$QUOTE" />
    <!-- Note: this particular input does not contain any quote to escape -->
    <xsl:value-of select="." />
    <xsl:value-of select="$QUOTE" />
  </xsl:template>

  <xsl:template mode="csv" match="node()">
    <xsl:value-of select="." />
  </xsl:template>

  <!-- disable default behavior: do not copy text nodes to output -->
  <xsl:template match="text()" mode="csv" />
  <xsl:template match="text()" />

</xsl:stylesheet>
