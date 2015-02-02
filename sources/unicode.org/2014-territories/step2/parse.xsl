<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
>

  <xsl:output mode="text" encoding="UTF-8" omit-xml-declaration="yes" />

  <xsl:variable name="NEWLINE" select="'&#xA;'" />
  <xsl:variable name="QUOTE">"</xsl:variable>
  <xsl:variable name="COMMA" select="','" />

  <xsl:template match="/">
    <!-- print headers -->
    <xsl:text>Territory Code,</xsl:text>
    <xsl:text>Name Type,</xsl:text>
    <xsl:text>Territory Name</xsl:text>
    <xsl:value-of select="$NEWLINE" />

    <xsl:apply-templates
      select="/ldml/localeDisplayNames/territories/territory"
    />
  </xsl:template>

  <xsl:template match="territory">
    <xsl:apply-templates mode="csv" select="@type" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="@alt" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="." />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

  <xsl:template mode="csv" match="node()[ contains(.,',') ]">
    <xsl:value-of select="$QUOTE" />
    <!-- Note: this particular input does not contain any quote to escape -->
    <xsl:value-of disable-output-escaping="yes" select="." />
    <xsl:value-of select="$QUOTE" />
  </xsl:template>

  <xsl:template mode="csv" match="node()">
    <xsl:value-of disable-output-escaping="yes" select="." />
  </xsl:template>

  <!-- disable default behavior: do not copy text nodes to output -->
  <xsl:template match="text()" mode="csv" />
  <xsl:template match="text()" />

</xsl:stylesheet>
