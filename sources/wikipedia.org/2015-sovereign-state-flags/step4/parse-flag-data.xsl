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
    select="concat($COMMA,$NEWLINE)"
  />

  <xsl:template match="/">
    <!-- print headers -->
    <xsl:text>File Name</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>File URL</xsl:text>
    <xsl:value-of select="$NEWLINE" />

    <xsl:variable
      name="title"
      select="
        /xhtml:html
        /xhtml:body
        /xhtml:div[@id='content'][1]
        /xhtml:h1[1]
      "
    />
    <xsl:message>
      <xsl:value-of select="$title" />
    </xsl:message>

    <xsl:variable
      name="imageLink"
      select="
        /xhtml:html
        /xhtml:body
        /xhtml:div[@id='content'][1]
        /xhtml:div[@id='bodyContent'][1]
        /xhtml:div[@id='mw-content-text'][1]
        /xhtml:div[@class='fullMedia'][1]
        /xhtml:a[. = 'Original file'][1]
      "
    />

    <xsl:variable name="fileName" select="$imageLink/@title" />
    <xsl:message>
      <xsl:text>  File Name: </xsl:text>
      <xsl:value-of select="$fileName" />
    </xsl:message>

    <xsl:variable name="url" select="$imageLink/@href" />
    <xsl:message>
      <xsl:text>  URL: </xsl:text>
      <xsl:value-of select="$url" />
    </xsl:message>

    <xsl:value-of select="$fileName" />
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="$url" />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

</xsl:stylesheet>
