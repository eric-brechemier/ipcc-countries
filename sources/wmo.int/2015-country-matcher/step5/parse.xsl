<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xhtml"
  version="1.0"
>

  <xsl:output method="xml" encoding="UTF-8" />

  <xsl:template match="/">
    <file>
      <header>
        <name>Country Name To Identify</name>
        <name>Matching Country Name</name>
        <name>ISO Country Code</name>
        <name>Matching Method</name>
      </header>

      <xsl:apply-templates
        select="//xhtml:table[1]"
      />
    </file>
  </xsl:template>

  <!-- skip header row -->
  <xsl:template match="xhtml:tr[xhtml:th]" />

  <xsl:template match="xhtml:tr">
    <record>
      <xsl:apply-templates />
    </record>
  </xsl:template>

  <xsl:template match="xhtml:th | xhtml:td">
    <field>
      <xsl:value-of select="." />
    </field>
  </xsl:template>

  <!-- disable default behavior: do not copy text nodes to output -->
  <xsl:template match="text()" />

</xsl:stylesheet>
