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
  <xsl:import href="../step2/count-records.xsl" />
  <xsl:import href="format-english-number.xsl" />

  <xsl:param name="cssPath" />
  <xsl:param name="csvPath" />
  <xsl:param name="picturePath" />

  <xsl:variable name="PROJECT_URL"
    >https://github.com/eric-brechemier/ipcc-countries</xsl:variable>

  <xsl:variable name="FIELD_ISO3_CODE" select="4" />
  <xsl:variable name="FIELD_COMMON_NAME" select="5" />
  <xsl:variable name="FIELD_WIKIPEDIA_URL" select="6" />
  <xsl:variable name="FIELD_CPDB_URL" select="7" />

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
          <xsl:call-template name="description-html" />
          <img class="how-dataviz" alt="" src="{$picturePath}" />
          <p>
            <xsl:text>Out of a total of </xsl:text>
            <xsl:text> </xsl:text>
            <a href="http://www.ipcc.ch/pdf/ipcc-principles/ipcc-principles-elections-rules.pdf#page=8">
              <xsl:call-template name="format-english-number">
                <xsl:with-param name="number">
                  <xsl:call-template name="total-ipcc-members" />
                </xsl:with-param>
              </xsl:call-template>
              <xsl:text> IPCC member states</xsl:text>
            </a>
            <xsl:text>, only </xsl:text>
            <xsl:call-template name="format-english-number">
              <xsl:with-param name="number">
                <xsl:call-template name="total-wmo-states-not-un" />
              </xsl:with-param>
            </xsl:call-template>
            <xsl:text> countries, </xsl:text>
            <xsl:apply-templates mode="list"
              select="record[
                    field[$FIELD_WMO] = 'WMO State'
                and field[$FIELD_UN] = 'NOT UN'
              ]"
            />
            <xsl:text>, are members of WMO but not UN members, and </xsl:text>
            <xsl:call-template name="format-english-number">
              <xsl:with-param name="number">
                <xsl:call-template name="total-un-states-not-wmo" />
              </xsl:with-param>
            </xsl:call-template>
            <xsl:text> countries (</xsl:text>
            <xsl:apply-templates mode="list"
              select="record[
                    field[$FIELD_UN] = 'UN'
                and field[$FIELD_WMO] = 'NOT WMO'
              ]"
            />
            <xsl:text>) are UN members but not WMO members. </xsl:text>
            <xsl:text>The other </xsl:text>
            <xsl:call-template name="format-english-number">
              <xsl:with-param name="number">
                <xsl:call-template name="total-states-both-wmo-and-un" />
              </xsl:with-param>
            </xsl:call-template>
            <xsl:text> IPCC countries are all members of both WMO and UN.</xsl:text>
          </p>
          <p>
            <xsl:text>As for the </xsl:text>
            <xsl:call-template name="format-english-number">
              <xsl:with-param name="number">
                <xsl:call-template name="total-wmo-territories" />
              </xsl:with-param>
            </xsl:call-template>
            <xsl:text> WMO Territories (</xsl:text>
            <xsl:apply-templates mode="list"
              select="record[
                field[$FIELD_WMO] = 'WMO Territory'
              ]"
            />
            <xsl:text>), since they are not states, </xsl:text>
            <xsl:text> they are not IPCC members.</xsl:text>
          </p>
          <hr />
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

  <xsl:template mode="list" match="record">
    <xsl:choose>
      <xsl:when test="position() = 1" />
      <xsl:when test="position() = last()">
        <xsl:text> and </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>, </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <a
      data-iso3="{field[$FIELD_ISO3_CODE]}"
    >
      <xsl:attribute name="href">
        <xsl:choose>
          <xsl:when test="field[$FIELD_WIKIPEDIA_URL]=''">
            <xsl:value-of select="field[$FIELD_CPDB_URL]" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="field[$FIELD_WIKIPEDIA_URL]" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:value-of select="field[$FIELD_COMMON_NAME]" />
    </a>
  </xsl:template>

</xsl:stylesheet>
