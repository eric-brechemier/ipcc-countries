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
    <xsl:apply-templates select="@language | @site" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="@value | @title" />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

  <xsl:template match="@language | @site">
    <xsl:value-of select="name(.)" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="." />
  </xsl:template>

  <xsl:template match="entity/claims/property/claim">
    <xsl:value-of select="../../../@id" />
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="name(../..)" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="../@id" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates select="mainsnak/datavalue" />
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

  <xsl:template match="datavalue[@type = 'wikibase-entityid']">
    <xsl:value-of select="@type" />
    <xsl:value-of select="$COMMA" />
    <xsl:apply-templates mode="csv" select="value/@numeric-id" />
  </xsl:template>

  <xsl:template match="datavalue">
    <xsl:message terminate="yes">
      <xsl:text>Unsupported datavalue type: </xsl:text>
      <xsl:value-of select="@type" />
    </xsl:message>
  </xsl:template>

  <xsl:template mode="csv" priority="2" match="@*[ contains(.,'&quot;') ]">
    <xsl:message terminate="yes">
      <xsl:text>FIXME: Add recursive escaping of quotes in CSV value.</xsl:text>
      <xsl:text>Quote to escape found in value: </xsl:text>
      <xsl:value-of select="." />
    </xsl:message>
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
