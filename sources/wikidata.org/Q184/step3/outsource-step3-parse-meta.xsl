<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xhtml"
  version="1.0"
>
  <xsl:param name="url" />
  <xsl:param name="file" />

  <xsl:output method="text" encoding="UTF-8" />

  <xsl:variable name="NEWLINE" select="'&#xA;'" />

  <xsl:template match="/">
    <xsl:apply-templates mode="year"
      select="
        /xhtml:html
        /xhtml:body
        /xhtml:div[@id='footer'][1]
        /xhtml:ul[@id='footer-info'][1]
        /xhtml:li[@id='footer-info-lastmod'][1]
      "
    />
    <xsl:apply-templates mode="title"
      select="
        /xhtml:html
        /xhtml:body
        /xhtml:div[@id='content'][1]
        /xhtml:h1[1]
      "
    />
    <xsl:call-template name="url" />
    <xsl:call-template name="file" />
    <xsl:call-template name="description" />
  </xsl:template>

  <xsl:template mode="year" match="xhtml:li[@id='footer-info-lastmod']">
    <!--
      Extract year from string of the form:
      'This page was last modified on dd Month YYYY, at hh:mm.'
    -->
    <xsl:text>Year: </xsl:text>
    <xsl:value-of select="
        substring-after(
          substring-after(
            substring-after(
              substring-before(.,','),
              'This page was last modified on '
            ),
            ' '
          ),
          ' '
        )
      "
    />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

  <xsl:template mode="title" match="xhtml:h1">
    <xsl:text>Title: </xsl:text>
    <xsl:value-of select="." />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

  <xsl:template name="url">
    <xsl:text>URL: </xsl:text>
    <xsl:value-of select="$url" />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

  <xsl:template name="file">
    <xsl:text>File: </xsl:text>
    <xsl:value-of select="$file" />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

  <xsl:template name="description">
    <xsl:value-of select="$NEWLINE" />
    <xsl:text>Description:</xsl:text>
    <xsl:value-of select="$NEWLINE" />
    <xsl:apply-templates mode="description"
      select="
        /xhtml:html
        /xhtml:body
        /xhtml:div[@id='content'][1]
        /xhtml:div[@id='bodyContent'][1]
        /xhtml:div[@id='siteSub'][1]
      "
    />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

  <xsl:template mode="description" match="xhtml:div[@id='siteSub']">
    <xsl:value-of select="." />
  </xsl:template>

</xsl:stylesheet>
