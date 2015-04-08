<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
>

  <xsl:output method="xml" encoding="UTF-8" />

  <xsl:template match="/">
    <file>
      <header>
        <name>Alpha-2 ISO Country Code</name>
        <name>Numeric ISO Country Code</name>
        <name>Alpha-3 ISO Country Code</name>
        <name>FIPS 10</name>
        <name>Internet TLD</name>
      </header>

      <xsl:apply-templates
        select="/supplementalData/codeMappings/territoryCodes"
      />
    </file>
  </xsl:template>

  <xsl:template match="territoryCodes">
    <record>
      <field><xsl:value-of select="@type" /></field>
      <field><xsl:value-of select="@numeric" /></field>
      <field><xsl:value-of select="@alpha3" /></field>
      <field><xsl:value-of select="@fips10" /></field>
      <field><xsl:value-of select="@internet" /></field>
    </record>
  </xsl:template>

  <!-- disable default behavior: do not copy text nodes to output -->
  <xsl:template match="text()" />

</xsl:stylesheet>
