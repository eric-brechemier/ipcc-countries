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
    <xsl:text>Page Id</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Page Namespace</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Page Title</xsl:text>
    <xsl:value-of select="$NEWLINE" />

    <xsl:apply-templates select="api/query/backlinks/bl" />
  </xsl:template>

  <xsl:template match="bl">
    <xsl:value-of select="@pageid" />
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="@ns" />
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="@title" />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

</xsl:stylesheet>
