<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
>

  <xsl:output method="xml" encoding="UTF-8" />

  <xsl:template match="/">
    <file>
      <header>
        <name>Page Id</name>
        <name>Page Namespace</name>
        <name>Page Title</name>
      </header>

      <xsl:apply-templates select="api/query/backlinks/bl" />
    </file>
  </xsl:template>

  <xsl:template match="bl">
    <record>
      <field><xsl:value-of select="@pageid" /></field>
      <field><xsl:value-of select="@ns" /></field>
      <field><xsl:value-of select="@title" /></field>
    </record>
  </xsl:template>

</xsl:stylesheet>
