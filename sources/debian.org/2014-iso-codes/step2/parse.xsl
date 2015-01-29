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
    <xsl:text>Alpha-3 Country Code,</xsl:text>
    <xsl:text>Numeric Code,</xsl:text>
    <xsl:text>Alpha-2 Country Code,</xsl:text>
    <xsl:text>Alpha-4 Country Code,</xsl:text>
    <xsl:text>Date Withdrawn,</xsl:text>
    <xsl:text>Common Name,</xsl:text>
    <xsl:text>Name,</xsl:text>
    <xsl:text>Official Name,</xsl:text>
    <xsl:text>Names,</xsl:text>
    <xsl:text>Comment</xsl:text>
    <xsl:value-of select="$NEWLINE" />

    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="iso_3166_entry | iso_3166_3_entry">
    <xsl:apply-templates mode="csv" select="@alpha_3_code" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="@numeric_code" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="@alpha_2_code" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="@alpha_4_code" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="@date_withdrawn" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="@common_name" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="@name" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="@official_name" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="@names" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="@comment" />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

  <xsl:template mode="csv" match="@*[ contains(.,',') ]">
    <xsl:value-of select="$QUOTE" />
    <!-- Note: this particular input does not contain any quote to escape -->
    <!-- but it contains & characters, which must be output AS IS -->
    <xsl:value-of disable-output-escaping="yes" select="." />
    <xsl:value-of select="$QUOTE" />
  </xsl:template>

  <xsl:template mode="csv" match="@*">
    <xsl:value-of disable-output-escaping="yes" select="." />
  </xsl:template>

  <!-- disable default behavior: do not copy text nodes to output -->
  <xsl:template match="text()" mode="csv" />
  <xsl:template match="text()" />

</xsl:stylesheet>
