<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xhtml"
  version="1.0"
>

  <xsl:output method="text" encoding="UTF-8" />

  <xsl:variable name="NEWLINE" select="'&#xA;'" />
  <xsl:variable name="QUOTE">"</xsl:variable>
  <xsl:variable name="COMMA" select="','" />

  <xsl:variable name="EMPTY_RECORD"
    select="concat($COMMA,$COMMA,$COMMA,$COMMA,$COMMA,$NEWLINE)"
  />

  <xsl:template match="/">
    <!-- print headers -->
    <xsl:text>Controlling State</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Group</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Country</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Flag Picture URL</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Flag URL</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Country URL</xsl:text>
    <xsl:value-of select="$NEWLINE" />

    <!-- select the heading of the first section with a list of countries -->
    <xsl:apply-templates
      select="
        //xhtml:div[@id='mw-content-text'][1]
        /xhtml:h2[1]
      "
    />
  </xsl:template>

  <xsl:template match="xhtml:h2">
    <xsl:variable name="controllingState" select="xhtml:span[1]" />
    <xsl:message>
      <xsl:text>Controlling State: </xsl:text>
      <xsl:value-of select="$controllingState"/>
    </xsl:message>
    <xsl:apply-templates select="following-sibling::*[1]">
      <xsl:with-param name="controllingState" select="$controllingState" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="xhtml:h3">
    <xsl:param name="controllingState" />
    <xsl:variable name="group" select="xhtml:span[1]" />
    <xsl:message>
      <xsl:text>  Group: </xsl:text>
      <xsl:value-of select="$group" />
    </xsl:message>
    <xsl:apply-templates select="following-sibling::*[1]">
      <xsl:with-param name="controllingState" select="$controllingState" />
      <xsl:with-param name="group" select="$group" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="xhtml:table">
    <xsl:param name="controllingState" />
    <xsl:param name="group" />

    <xsl:apply-templates mode="flag"
      select="xhtml:tr/xhtml:td/xhtml:table"
    >
      <xsl:with-param name="controllingState" select="$controllingState" />
      <xsl:with-param name="group" select="$group" />
    </xsl:apply-templates>

    <xsl:value-of select="$EMPTY_RECORD" />

    <xsl:apply-templates select="following-sibling::*[1]">
      <xsl:with-param name="controllingState" select="$controllingState" />
      <xsl:with-param name="group" select="$group" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template mode="flag" match="xhtml:table">
    <xsl:param name="controllingState" />
    <xsl:param name="group" />

    <xsl:variable name="country"
      select="xhtml:tr[2]/xhtml:td[1]/xhtml:a[2]"
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

    <xsl:value-of select="$controllingState" />
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="$group" />
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="$country" />
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="$flagPictureUri" />
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="$flagUri" />
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="$countryUri" />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

  <!-- continue with next element -->
  <xsl:template match="xhtml:*">
    <xsl:param name="controllingState" />
    <xsl:param name="group" />
    <xsl:apply-templates select="following-sibling::*[1]">
      <xsl:with-param name="controllingState" select="$controllingState" />
      <xsl:with-param name="group" select="$group" />
    </xsl:apply-templates>
  </xsl:template>

  <!-- stop on the first heading after lists of countries ('See also') -->
  <xsl:template match="xhtml:h2[xhtml:span[1] = 'See also']" />

</xsl:stylesheet>
