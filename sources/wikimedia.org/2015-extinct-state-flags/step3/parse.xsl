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

  <xsl:variable name="EMPTY_RECORD"
    select="concat($COMMA,$COMMA,$COMMA,$COMMA)"
  />

  <xsl:template match="/">
    <!-- print headers -->
    <xsl:text>Region</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Description</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Flag Picture URL</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Flag URL</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Country URL</xsl:text>

    <!-- select the heading of the first section with a list of countries -->
    <xsl:apply-templates
      select="
        //xhtml:div[@id='mw-content-text'][1]
        /xhtml:h2[1]
      "
    />
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

    <xsl:value-of select="$NEWLINE" />
    <xsl:value-of select="$EMPTY_RECORD" />

    <xsl:apply-templates select="following-sibling::*[1]">
      <xsl:with-param name="region" select="$region" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template mode="flag" match="xhtml:table">
    <xsl:param name="region" />

    <xsl:variable name="description">
      <xsl:call-template name="csvField">
        <xsl:with-param name="text"
          select="xhtml:tr[2]/xhtml:td[1]"
        />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="flagPictureUri">
      <xsl:call-template name="csvField">
        <xsl:with-param name="text"
          select="xhtml:tr[1]/xhtml:td[1]/xhtml:a[1]/@href"
        />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="flagUri">
      <xsl:call-template name="csvField">
        <xsl:with-param name="text"
          select="xhtml:tr[2]/xhtml:td[1]/xhtml:a[1]/@href"
        />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="countryUri">
      <xsl:call-template name="csvField">
        <xsl:with-param name="text"
          select="xhtml:tr[2]/xhtml:td[1]/xhtml:a[2]/@href"
        />
      </xsl:call-template>
    </xsl:variable>

    <xsl:value-of select="$NEWLINE" />
    <xsl:value-of select="$region" />
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="$description" />
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="$flagPictureUri" />
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="$flagUri" />
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="$countryUri" />
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

  <xsl:template name="csvField">
    <xsl:param name="text" />

    <xsl:choose>
      <xsl:when test="contains($text,$COMMA)">
        <xsl:value-of select="$QUOTE" />
        <!--
          NOTE: this particular input does not contain any quote to escape
        -->
        <xsl:value-of select="$text" />
        <xsl:value-of select="$QUOTE" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
