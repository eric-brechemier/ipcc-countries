<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xhtml"
  version="1.0"
>

  <xsl:output mode="text" encoding="UTF-8" omit-xml-declaration="yes" />

  <xsl:variable name="NEWLINE" select="'&#xA;'" />
  <xsl:variable name="QUOTE">"</xsl:variable>
  <xsl:variable name="COMMA" select="','" />

  <xsl:template match="/">
    <!-- print headers -->
    <xsl:text>Member State,Date of Admission</xsl:text>
    <xsl:value-of select="$NEWLINE" />

    <xsl:apply-templates
      select="//xhtml:div[@id='memberlist'][1]"
    />
  </xsl:template>

  <xsl:template match="xhtml:p[@class='abc']">
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

  <xsl:template
    match="xhtml:ul[ starts-with(@class,'memberlistcountry') ]"
  >
    <xsl:for-each select="xhtml:li">
      <xsl:apply-templates mode="csv" select="." />
      <xsl:if test="following-sibling::xhtml:li">
        <xsl:value-of select="$COMMA" />
      </xsl:if>
    </xsl:for-each>
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

  <xsl:template mode="csv" match="xhtml:li">
    <!--
      1. remove '*' found at end of country names
      2. replace new lines with spaces,
         and remove white space from start/end of country name
    -->
    <xsl:value-of
      select="normalize-space( translate(.,'*','') )"
    />
  </xsl:template>

  <!-- disable default behavior: do not copy text nodes to output -->
  <xsl:template match="text()" mode="csv" />
  <xsl:template match="text()" />

</xsl:stylesheet>
