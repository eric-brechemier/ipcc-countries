<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  version="1.0"
>
  <!--
  List IPCC Countries with flags and links to Wikipedia pages

  Parameter:
    * flagsPath - string, relative path to the SVG image for flags

  Input:
    XML without namespace, with the following structure,
    * file - root element, contains a header element
             followed with a list of record elements
    * header - element, contains a list of name elements
    * name - element, contains text
    * record - element, contains a list of field elements
    * field - element, contains text

  Output:
    XHTML file for the visualization,
    starting with a header:
    - a title
    - a navigation area (three links for who, what, where),
    followed with an article:
    - a header, with heading and description
    - a list of initials of country names and countries

    Each country is represented by its flag and country name;
    the country name displayed is the common name;
    the official name of the country is displayed, as title, on hover.
    Both the flag image and the country name link to the Wikipedia page
    about the country.
  -->

  <xsl:param name="flagsPath" />

  <xsl:output method="html"
    encoding="UTF-8"
    omit-xml-declaration="yes"
    doctype-public="about:legacy-compat"
    indent="yes"
  />

  <xsl:template name="title">
    <xsl:text>Who are the Member Countries of the </xsl:text>
    <xsl:text>Intergovernmental Panel on Climate Change (IPCC)?</xsl:text>
  </xsl:template>

  <xsl:template name="description-text">
    <xsl:text>There are currently 195 countries member of the IPCC.</xsl:text>
  </xsl:template>

  <xsl:template name="description-html">
    <xsl:text>There are currently </xsl:text>
    <a href="http://www.ipcc.ch/pdf/ipcc-principles/ipcc-principles-elections-rules.pdf#page=8"
      >195 countries</a>
    <xsl:text> member of the </xsl:text>
    <a href="http://ipcc.ch/">IPCC</a>
    <xsl:text>.</xsl:text>
  </xsl:template>

  <xsl:template name="navigation">
    <li>who</li>
    <!--li><a href="what.html">what</a></li-->
    <!--li><a href="where.html">where</a></li-->
  </xsl:template>

  <xsl:template match="file">
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <title>
          <xsl:call-template name="title" />
        </title>
        <meta name="description">
          <xsl:attribute name="content">
            <xsl:call-template name="description-text" />
          </xsl:attribute>
        </meta>
      </head>
      <body>
        <header>
          <h1>IPCC Countries</h1>
          <nav>
            <ul>
              <xsl:call-template name="navigation" />
            </ul>
          </nav>
        </header>
        <article>
          <header>
            <h1>
              <xsl:call-template name="title" />
            </h1>
            <p>
              <xsl:call-template name="description-html" />
            </p>
          </header>
          <ul>
            <xsl:apply-templates />
          </ul>
        </article>
        <!--xsl:message>
          <xsl:text>Path: </xsl:text>
          <xsl:value-of select="$flagsPath" />
        </xsl:message>
        <xsl:copy-of select="document($flagsPath)/*" /-->
      </body>
    </html>
  </xsl:template>

  <!-- skip header -->
  <xsl:template match="header" />

  <xsl:template match="record">
    <xsl:variable name="INITIAL"       select="1" />
    <xsl:variable name="ISO3"          select="2" />
    <xsl:variable name="COMMON_NAME"   select="3" />
    <xsl:variable name="OFFICIAL_NAME" select="4" />
    <xsl:variable name="FLAG"          select="5" />
    <xsl:variable name="WIKIPEDIA_URL" select="6" />

    <xsl:variable name="initial" select="field[$INITIAL]" />
    <xsl:variable name="url" select="field[$WIKIPEDIA_URL]" />

    <xsl:if
      test="not( preceding-sibling::record[1]/field[$INITIAL][. = $initial] )"
    >
      <!-- new initial -->
      <li class="initial"><xsl:value-of select="$initial" /></li>
    </xsl:if>
    <li class="country" data-iso3="{ field[$ISO3] }">
      <a href="{$url}" class="flag">
        <svg xmlns="http://www.w3.org/2000/svg" width="360" height="270">
          <use xlink:href="{concat($flagsPath,'#',field[$FLAG])}" />
        </svg>
      </a>
      <a href="{$url}" class="name" title="{ field[$OFFICIAL_NAME] }">
        <xsl:value-of select="field[$COMMON_NAME]" />
      </a>
    </li>
  </xsl:template>

</xsl:stylesheet>
