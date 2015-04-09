<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xhtml"
  version="1.0"
>
  <xsl:param name="imageFile" />

  <xsl:output method="xml" encoding="UTF-8" />

  <xsl:template match="/">
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
      <xsl:text>Processing </xsl:text>
      <xsl:value-of select="$title" />
    </xsl:message>

    <file>
      <header>
        <name>Page Title</name>
        <name>Image URL</name>
        <name>Local Image File</name>
      </header>

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
        <xsl:text>Page Title: </xsl:text>
        <xsl:value-of select="$fileName" />
      </xsl:message>

      <xsl:variable name="url" select="$imageLink/@href" />
      <xsl:message>
        <xsl:text>Image URL: </xsl:text>
        <xsl:value-of select="$url" />
      </xsl:message>

      <record>
        <field><xsl:value-of select="$fileName" /></field>
        <field><xsl:value-of select="$url" /></field>
        <field><xsl:value-of select="$imageFile" /></field>
      </record>
    </file>

    <xsl:message>
      <xsl:text>Success.</xsl:text>
    </xsl:message>
  </xsl:template>

</xsl:stylesheet>
