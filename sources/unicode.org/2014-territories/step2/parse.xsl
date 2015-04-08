<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
>

  <xsl:output method="xml" encoding="UTF-8" />

  <xsl:template match="/">
    <file>
      <header>
        <name>Territory Code</name>
        <name>Name Type</name>
        <name>Territory Name</name>
      </header>

      <xsl:apply-templates
        select="/ldml/localeDisplayNames/territories/territory"
      />
    </file>
  </xsl:template>

  <xsl:template match="territory">
    <record>
      <field><xsl:apply-templates mode="csv" select="@type" /></field>
      <field><xsl:apply-templates mode="csv" select="@alt" /></field>
      <field><xsl:apply-templates mode="csv" select="." /></field>
    </record>
  </xsl:template>

  <!-- disable default behavior: do not copy text nodes to output -->
  <xsl:template match="text()" />

</xsl:stylesheet>
