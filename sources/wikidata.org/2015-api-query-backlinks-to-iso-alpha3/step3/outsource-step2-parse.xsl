<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
>

  <xsl:output method="text" encoding="UTF-8" />

  <xsl:variable name="NEWLINE" select="'&#xA;'" />
  <xsl:variable name="QUOTE">"</xsl:variable>
  <xsl:variable name="COMMA" select="','" />

  <xsl:variable
    name="EMPTY_RECORD"
    select="concat($COMMA,$COMMA,$COMMA,$COMMA,$NEWLINE)"
  />

  <xsl:template match="/">
    <!-- print headers -->
    <xsl:text>Entity</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Group</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Property Name or Language Code or Site Identifier</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Value Type</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Value or Title</xsl:text>
    <xsl:value-of select="$NEWLINE" />

    <xsl:apply-templates select="entity/entities/entity" />
  </xsl:template>

  <xsl:template match="entity">
    <xsl:message>
      <xsl:text>Processing Entity: </xsl:text>
      <xsl:value-of select="@id" />
    </xsl:message>
    <xsl:apply-templates />
    <xsl:message>
      <xsl:text>Success.</xsl:text>
    </xsl:message>
  </xsl:template>

  <!-- insert an empty record after each group except the last -->
  <xsl:template match="entity/*">
    <xsl:apply-templates />
    <xsl:if test="following-sibling::*">
      <xsl:value-of select="$EMPTY_RECORD" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="entity/aliases/alias">
    <xsl:value-of select="../../@id" />
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="name(..)" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="@language" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="@value" />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

  <xsl:template match="
      entity/aliases/alias
    | entity/descriptions/description
    | entity/labels/label
    | entity/sitelinks/sitelink
    "
  >
    <xsl:value-of select="../../@id" />
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="name(..)" />
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="name( @language | @site )" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="@language | @site" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="@value | @title" />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

  <xsl:template match="entity/claims/property/claim[ not(mainsnak/datavalue) ]"
  >
    <xsl:message terminate="yes">
      <xsl:text>Assertion Error: claim without mainsnak/datavalue</xsl:text>
      <xsl:copy-of select="." />
    </xsl:message>
  </xsl:template>

  <xsl:template match="entity/claims/property/claim">
    <xsl:apply-templates select="mainsnak/datavalue" />
  </xsl:template>

  <xsl:template mode="common-properties" match="datavalue">
    <xsl:value-of select="ancestor::entity/@id" />
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="name( ancestor::claims )" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="ancestor::property/@id" />
    <xsl:value-of select="$COMMA" />
  </xsl:template>

  <xsl:template match="datavalue[@type = 'string']">
    <xsl:apply-templates mode="common-properties" select="." />
    <xsl:apply-templates mode="csv" select="@type" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="@value" />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

  <xsl:template match="datavalue[@type = 'wikibase-entityid']">
    <xsl:apply-templates mode="common-properties" select="." />
    <xsl:apply-templates mode="csv" select="value/@entity-type" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="value/@numeric-id" />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

  <xsl:template match="datavalue[@type = 'quantity']">
    <xsl:apply-templates mode="common-properties" select="." />
    <xsl:apply-templates mode="csv" select="value/@unit" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="value/@amount" />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

  <xsl:template match="datavalue[@type = 'globecoordinate']">
    <xsl:apply-templates mode="globecoordinate"
      select="
        value/@latitude
      | value/@longitude
      | value/@altitude
      "
    />
  </xsl:template>

  <xsl:template mode="globecoordinate" match="value/@*[. != '']">
    <xsl:apply-templates mode="common-properties" select="../.." />
    <xsl:value-of select="name( . )" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="." />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

  <xsl:template match="datavalue[@type = 'monolingualtext']">
    <xsl:apply-templates mode="common-properties" select="." />
    <xsl:apply-templates mode="csv" select="@type" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="value/@text" />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

  <xsl:template match="datavalue[@type = 'time']">
    <xsl:apply-templates mode="common-properties" select="." />
    <xsl:apply-templates mode="csv" select="@type" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="value/@time" />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

  <xsl:template match="datavalue">
    <xsl:message terminate="yes">
      <xsl:text>Error: Unsupported datavalue type: </xsl:text>
      <xsl:value-of select="@type" />
    </xsl:message>
  </xsl:template>

  <xsl:template mode="csv" priority="2" match="@*[ contains(.,'&quot;') ]">
    <xsl:value-of select="$QUOTE" />
    <xsl:call-template name="escapeCsv">
      <xsl:with-param name="text" select="." />
    </xsl:call-template>
    <xsl:value-of select="$QUOTE" />
  </xsl:template>

  <!--
  Convert text to be part of a CSV value, escaping quotes by doubling them

  Note:
  this function does not handle the optional wrapping of the whole value
  in quotes, and does not return an indication of whether quotes have been
  replaced or not.

  The presence of a quote and/or comma in the CSV value should be tested
  beforehand, and this function only called when a quote is present.
  -->
  <xsl:template name="escapeCsv">
    <xsl:param name="text" />
    <xsl:choose>
      <xsl:when test="contains($text, $QUOTE)">
        <xsl:value-of select="substring-before($text, $QUOTE)" />
        <!-- double the quote to escape it -->
        <xsl:value-of select="$QUOTE" />
        <xsl:value-of select="$QUOTE" />
        <!-- recursion on right part of the text, after the quote -->
        <xsl:call-template name="escapeCsv">
          <xsl:with-param
            name="text"
            select="substring-after($text, $QUOTE)"
          />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- end recursion -->
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="csv" match="@*[ contains(.,',') ]">
    <xsl:value-of select="$QUOTE" />
    <xsl:value-of select="." />
    <xsl:value-of select="$QUOTE" />
  </xsl:template>

  <xsl:template mode="csv" match="@*">
    <xsl:value-of select="." />
  </xsl:template>

  <!-- disable copy of text nodes (by default) -->
  <xsl:template match="text()" />

</xsl:stylesheet>
