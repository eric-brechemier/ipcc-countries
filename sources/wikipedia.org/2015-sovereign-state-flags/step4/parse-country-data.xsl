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
    select="concat($COMMA,$COMMA,$COMMA,$NEWLINE)"
  />

  <xsl:template match="/">
    <!-- print headers -->
    <xsl:text>Country</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Official English Name</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Official Native Name (Language)</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Alpha-2 ISO Code</xsl:text>
    <xsl:value-of select="$NEWLINE" />

    <xsl:variable
      name="country"
      select="
        /xhtml:html
        /xhtml:body
        /xhtml:div[@id='content'][1]
        /xhtml:h1[1]
      "
    />
    <xsl:message>
      <xsl:text>Country: </xsl:text>
      <xsl:value-of select="$country" />
    </xsl:message>

    <xsl:variable
      name="infobox"
      select="
        /xhtml:html
        /xhtml:body
        /xhtml:div[@id='content'][1]
        /xhtml:div[@id='bodyContent'][1]
        /xhtml:div[@id='mw-content-text'][1]
        /xhtml:table[@class='infobox geography vcard'][1]
      "
    />

    <xsl:variable name="englishCountryName"
      select="
        $infobox
        /xhtml:tr[1]
        /xhtml:th[1]
        /xhtml:span[@class='fn org country-name'][1]
      "
    />
    <xsl:message>
      <xsl:text>English Name: </xsl:text>
      <xsl:value-of select="$englishCountryName" />
    </xsl:message>

    <xsl:variable name="nativeCountryName"
      select="
        normalize-space(
          translate(
            $infobox
            /xhtml:tr[1]
            /xhtml:th[1]
            /xhtml:div[1],
            '&#160;',
            ' '
          )
        )
      "
    />
    <xsl:message>
      <xsl:text>Native Name: </xsl:text>
      <xsl:value-of select="$nativeCountryName" />
    </xsl:message>

    <xsl:variable name="alpha2Code"
      select="
        $infobox
        /xhtml:tr
        /xhtml:th[ xhtml:a/@title = 'ISO 3166' ][1]
        /following-sibling::xhtml:td[1]
      "
    />
    <xsl:message>
      <xsl:text>Alpha-2 ISO Code: </xsl:text>
      <xsl:value-of select="$alpha2Code" />
    </xsl:message>

    <xsl:call-template name="csvField">
      <xsl:with-param name="text" select="$country" />
    </xsl:call-template>
    <xsl:value-of select="$COMMA" />
    <xsl:call-template name="csvField">
      <xsl:with-param name="text" select="$englishCountryName" />
    </xsl:call-template>
    <xsl:value-of select="$COMMA" />
    <xsl:call-template name="csvField">
      <xsl:with-param name="text" select="$nativeCountryName" />
    </xsl:call-template>
    <xsl:value-of select="$COMMA" />
    <xsl:call-template name="csvField">
      <xsl:with-param name="text" select="$alpha2Code" />
    </xsl:call-template>
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

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
