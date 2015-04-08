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
        <name>Member State</name>
        <name>Date of Admission</name>
      </header>

      <xsl:apply-templates
        select="//xhtml:div[@id='memberlist'][1]"
      />
    </file>
  </xsl:template>

  <xsl:template name="emptyRecord">
    <record>
      <field />
      <field />
    </record>
  </xsl:template>

  <xsl:template match="xhtml:p[@class='abc']">
    <xsl:call-template name="emptyRecord" />
  </xsl:template>

  <xsl:template
    match="xhtml:ul[ starts-with(@class,'memberlistcountry') ]"
  >
    <record>
      <xsl:apply-templates mode="country" select="xhtml:li" />
    </record>
  </xsl:template>

  <xsl:template mode="country" match="xhtml:li">
    <field>
      <!--
        1. remove '*' found at end of country names
        2. replace new lines with spaces,
           and remove white space from start/end of country name
      -->
      <xsl:value-of
        select="normalize-space( translate(.,'*','') )"
      />
    </field>
  </xsl:template>

  <!-- disable default behavior: do not copy text nodes to output -->
  <xsl:template mode="country" match="text()" />
  <xsl:template match="text()" />

</xsl:stylesheet>
