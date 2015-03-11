<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
>

  <xsl:output method="text" encoding="UTF-8" />

  <xsl:variable name="NEWLINE" select="'&#xA;'" />

  <xsl:template match="/">
    <xsl:apply-templates select="entity/entities/entity" />
  </xsl:template>

  <xsl:template match="entity">
    <xsl:text>Year: </xsl:text>
    <xsl:value-of select="substring-before(@modified,'-')" />
    <xsl:value-of select="$NEWLINE" />

    <xsl:text>Title: </xsl:text>
    <xsl:value-of select="labels/label[@language='en'][1]/@value" />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

</xsl:stylesheet>
