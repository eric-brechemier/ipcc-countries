<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  version="1.0"
>
  <!--
  List IPCC Countries with flags and links to Wikipedia pages

  Parameters:
    * cssPath - string, relative path to the CSS style sheet
    * csvPath - string, relative path to the CSV data

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
    - a paragraph with links to the CSV data and the GitHub project

    Each country is represented by its flag and country name;
    the country name displayed is the common name;
    the official name of the country is displayed, as title, on hover.
    Both the flag image and the country name link to the Wikipedia page
    about the country.
  -->

  <xsl:param name="cssPath" />
  <xsl:param name="csvPath" />

  <xsl:variable name="PROJECT_URL"
    >https://github.com/eric-brechemier/ipcc-countries</xsl:variable>

  <xsl:output method="html"
    encoding="UTF-8"
    omit-xml-declaration="yes"
    indent="yes"
  />

  <xsl:template name="html5-doctype">
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
  </xsl:template>

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
    <li><a href="../how/">how</a></li>
    <!--li><a href="where.html">where</a></li-->
  </xsl:template>

  <xsl:template match="file">
    <xsl:call-template name="html5-doctype" />
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
        <link rel="stylesheet" href="{$cssPath}" />
      </head>
      <body>
        <header>
          <h1><a href="{$PROJECT_URL}">IPCC Countries</a></h1>
          <nav>
            <ul>
              <xsl:call-template name="navigation" />
            </ul>
          </nav>
        </header>
        <article>
          <h1>
            <xsl:call-template name="title" />
          </h1>
          <p>
            <xsl:call-template name="description-html" />
          </p>
          <ul class="countries">
            <xsl:apply-templates />
          </ul>
          <p>
            <xsl:text>You can </xsl:text>
            <a href="{$csvPath}">download this list in CSV format</a>
            <xsl:text> or </xsl:text>
            <a href="{$PROJECT_URL}"
              >browse the whole project on GitHub</a>
            <xsl:text>.</xsl:text>
          </p>
        </article>
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
    <xsl:variable name="id" select="field[$FLAG]" />
    <xsl:variable name="url" select="field[$WIKIPEDIA_URL]" />

    <xsl:if
      test="not( preceding-sibling::record[1]/field[$INITIAL][. = $initial] )"
    >
      <!-- new initial -->
      <li class="initial"><xsl:value-of select="$initial" /></li>
    </xsl:if>
    <li class="country" data-iso3="{ field[$ISO3] }">
      <a href="{$url}" class="{$id} sprite flag">
      </a>
      <a href="{$url}" class="name" title="{ field[$OFFICIAL_NAME] }">
        <xsl:value-of select="field[$COMMON_NAME]" />
      </a>
    </li>
  </xsl:template>

</xsl:stylesheet>
