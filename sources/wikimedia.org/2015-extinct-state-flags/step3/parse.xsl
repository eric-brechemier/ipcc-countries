<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xhtml"
  version="1.0"
>

  <xsl:output method="xml" encoding="UTF-8" />

  <xsl:template name="emptyRecord">
    <record>
      <field />
      <field />
      <field />
      <field />
      <field />
    </record>
  </xsl:template>

  <xsl:template match="/">
    <file>
      <header>
        <name>Region</name>
        <name>Description</name>
        <name>Flag Picture URL</name>
        <name>Flag URL</name>
        <name>Country URL</name>
      </header>

      <!-- select the heading of the first section with a list of countries -->
      <xsl:apply-templates
        select="
          //xhtml:div[@id='mw-content-text'][1]
          /xhtml:h2[1]
        "
      />
    </file>
  </xsl:template>

  <xsl:template match="xhtml:h2">
    <xsl:variable name="region" select="xhtml:span[1]" />
    <xsl:message>
      <xsl:text>Region: </xsl:text>
      <xsl:value-of select="$region"/>
    </xsl:message>
    <xsl:apply-templates select="following-sibling::*[1]">
      <xsl:with-param name="region" select="$region" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="xhtml:table">
    <xsl:param name="region" />

    <xsl:apply-templates mode="flag"
      select="xhtml:tr/xhtml:td/xhtml:table"
    >
      <xsl:with-param name="region" select="$region" />
    </xsl:apply-templates>

    <xsl:call-template name="emptyRecord" />

    <xsl:apply-templates select="following-sibling::*[1]">
      <xsl:with-param name="region" select="$region" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template mode="flag" match="xhtml:table">
    <xsl:param name="region" />

    <xsl:variable name="description"
      select="xhtml:tr[2]/xhtml:td[1]"
    />
    <xsl:variable name="flagPictureUri"
      select="xhtml:tr[1]/xhtml:td[1]/xhtml:a[1]/@href"
    />
    <xsl:variable name="flagUri"
      select="xhtml:tr[2]/xhtml:td[1]/xhtml:a[1]/@href"
    />
    <xsl:variable name="countryUri"
      select="xhtml:tr[2]/xhtml:td[1]/xhtml:a[2]/@href"
    />

    <record>
      <field><xsl:value-of select="$region" /></field>
      <field><xsl:value-of select="$description" /></field>
      <field><xsl:value-of select="$flagPictureUri" /></field>
      <field><xsl:value-of select="$flagUri" /></field>
      <field><xsl:value-of select="$countryUri" /></field>
    </record>
  </xsl:template>

  <!-- continue with next element -->
  <xsl:template match="xhtml:*">
    <xsl:param name="region" />
    <xsl:apply-templates select="following-sibling::*[1]">
      <xsl:with-param name="region" select="$region" />
    </xsl:apply-templates>
  </xsl:template>

  <!-- stop on the first heading after lists of countries ('See also') -->
  <xsl:template match="xhtml:h2[xhtml:span[1] = 'See also']" />

</xsl:stylesheet>
