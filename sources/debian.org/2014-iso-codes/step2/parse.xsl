<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
>

  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <xsl:template match="/">
    <file>
      <header>
        <name>Alpha-2 Country Code</name>
        <name>Alpha-4 Country Code</name>
        <name>Alpha-3 Country Code</name>
        <name>Numeric Code</name>
        <name>Common Name</name>
        <name>Name</name>
        <name>Official Name</name>
        <name>Date Withdrawn</name>
        <name>Names</name>
        <name>Comment</name>
      </header>
      <xsl:apply-templates />
    </file>
  </xsl:template>

  <xsl:template match="iso_3166_entry | iso_3166_3_entry">
    <record>
      <field><xsl:value-of select="@alpha_2_code" /></field>
      <field><xsl:value-of select="@alpha_4_code" /></field>
      <field><xsl:value-of select="@alpha_3_code" /></field>
      <field><xsl:value-of select="@numeric_code" /></field>
      <field><xsl:value-of select="@common_name" /></field>
      <field><xsl:value-of select="@name" /></field>
      <field><xsl:value-of select="@official_name" /></field>
      <field><xsl:value-of select="@date_withdrawn" /></field>
      <field><xsl:value-of select="@names" /></field>
      <field><xsl:value-of select="@comment" /></field>
    </record>
  </xsl:template>

  <!-- disable default behavior: do not copy text nodes to output -->
  <xsl:template match="text()" />

</xsl:stylesheet>
