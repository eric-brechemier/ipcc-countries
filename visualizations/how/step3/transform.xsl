<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  version="1.0"
>
  <!--
  Display a visualization to explain how countries become IPCC Members

  Parameters:
    * cssPath - string, relative path to the CSS style sheet
    * csvPath - string, relative path to the CSV data
    * picturePath - string, relative path to visualization picture

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
    - a paragraph of explanation and the visualization picture
    - a paragraph with links to the CSV data and the GitHub project

    The copy gives details about the picture, giving the numbers
    of countries in each group (both lines and curved shapes)
    and listing explicitly the countries in the small groups:
    * UN states not part of WMO
    * WMO states not part of UN
    * WMO Territories
  -->

  <xsl:param name="cssPath" />
  <xsl:param name="csvPath" />
  <xsl:param name="picturePath" />

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
    <xsl:text>How does a country become a member of the </xsl:text>
    <xsl:text>Intergovernmental Panel on Climate Change (IPCC)?</xsl:text>
  </xsl:template>

  <xsl:template name="description-text">
    <xsl:text>Any state (not territories) member of the UN or WMO </xsl:text>
    <xsl:text>becomes ipso facto a member of the IPCC.</xsl:text>
  </xsl:template>

  <xsl:template name="description-html">
    <p>
      <xsl:text>Any </xsl:text>
      <em>state</em>
      <xsl:text> member of the </xsl:text>
      <a href="http://www.un.org/en/members/">United Nations (UN)</a>
      <xsl:text> or the </xsl:text>
      <a href="https://www.wmo.int/pages/members/membership/index_en.php"
        >World Meteorological Organization (WMO)</a>
      <xsl:text> becomes ipso facto a </xsl:text>
      <a href="http://www.ipcc.ch/pdf/ipcc-principles/ipcc-principles-elections-rules.pdf#page=8"
        >member</a>
      <xsl:text> of the </xsl:text>
      <a href="http://ipcc.ch/">Intergovernmental Panel on Climate Change (IPCC)</a>
      <xsl:text>.</xsl:text>
    </p>
    <p>
      <xsl:text>While all UN members are states, </xsl:text>
      <xsl:text>WMO members can be states or territories; </xsl:text>
      <xsl:text>only states are IPCC members, </xsl:text>
      <em>not territories</em>
      <xsl:text>.</xsl:text>
    </p>
  </xsl:template>

  <xsl:template name="navigation">
    <li><a href="../who/">who</a></li>
    <li>how</li>
    <!--li><a href="where.html">where</a></li-->
  </xsl:template>

  <xsl:variable name="FIELD_IPCC" select="1" />

  <xsl:template match="file">
    <xsl:variable name="totalIpccMembers"
      select="count(
        record[ field[$FIELD_IPCC] = 'IPCC' ]
      )"
    />

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
          <xsl:call-template name="description-html" />
          <img src="{$picturePath}">
            <xsl:attribute name="alt">
              <xsl:call-template name="description-text" />
            </xsl:attribute>
          </img>
          <p>
            <xsl:text>Out of a total of </xsl:text>
            <xsl:value-of select="$totalIpccMembers" />
            <xsl:text> </xsl:text>
            <a href="http://www.ipcc.ch/pdf/ipcc-principles/ipcc-principles-elections-rules.pdf#page=8"
              >IPCC members</a>
            <xsl:text>, only </xsl:text>
          </p>
          <p>
            <xsl:text>You can </xsl:text>
            <a href="{$csvPath}">
              <xsl:text>download the data </xsl:text>
              <xsl:text>used for this visualization </xsl:text>
              <xsl:text>in CSV format</xsl:text>
            </a>
            <xsl:text> or </xsl:text>
            <a href="{$PROJECT_URL}"
              >browse the whole project on GitHub</a>
            <xsl:text>.</xsl:text>
          </p>
        </article>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
