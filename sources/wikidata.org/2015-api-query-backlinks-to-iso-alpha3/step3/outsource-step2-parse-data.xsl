<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
>

  <xsl:output method="xml" encoding="UTF-8" />

  <xsl:template name="emptyRecord">
    <record>
      <field />
      <field />
      <field />
      <field />
      <field />
      <field />
      <field />
      <field />
    </record>
  </xsl:template>

  <xsl:template match="/">
    <file>
      <header>
        <name>Entity</name>
        <name>Group</name>
        <name>Value Name</name>
        <name>Value Type</name>
        <name>Value</name>
        <name>Rank</name>
        <name>Start Time</name>
        <name>End Time</name>
      </header>

      <xsl:apply-templates select="entity/entities/entity" />
    </file>
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
      <xsl:call-template name="emptyRecord" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="
      entity/aliases/alias
    | entity/descriptions/description
    | entity/labels/label
    | entity/sitelinks/sitelink
    "
  >
    <record>
      <field><xsl:value-of select="../../@id" /></field>
      <field><xsl:value-of select="name(.)" /></field>
      <field><xsl:value-of select="name( @language | @site )" /></field>
      <field><xsl:value-of select="@language | @site" /></field>
      <field><xsl:value-of select="@value | @title" /></field>
      <field />
      <field />
      <field />
    </record>
  </xsl:template>

  <xsl:template match="entity/claims/property/claim">
    <xsl:apply-templates select="mainsnak" />
  </xsl:template>

  <xsl:template mode="start-claim" match="mainsnak">
    <xsl:param name="valueType" select="@datatype" />
    <field><xsl:value-of select="ancestor::entity/@id" /></field>
    <field><xsl:value-of select="name(..)" /></field>
    <field><xsl:value-of select="@property" /></field>
    <field><xsl:value-of select="$valueType" /></field>
  </xsl:template>

  <xsl:template mode="end-claim" match="mainsnak">
    <field />
    <field>
      <xsl:value-of select="../@rank" />
    </field>
    <field>
      <!-- start time -->
      <xsl:value-of
        select="
          ../qualifiers
          /property[@id='P580']
          /qualifiers
          /datavalue
          /value
          /@time
        "
      />
    </field>
    <field>
      <!-- end time -->
      <xsl:value-of
        select="
          ../qualifiers
          /property[@id='P582']
          /qualifiers
          /datavalue
          /value
          /@time
        "
      />
    </field>
  </xsl:template>

  <xsl:template
    match="
      mainsnak[
           @datatype = 'string'
        or @datatype = 'commonsMedia'
        or @datatype = 'url'
      ]
    "
  >
    <record>
      <xsl:apply-templates mode="start-claim" select="." />
      <field>
        <xsl:value-of select="datavalue/@value" />
      </field>
      <xsl:apply-templates mode="end-claim" select="." />
    </record>
  </xsl:template>

  <xsl:template match="mainsnak[@datatype = 'wikibase-item']">
    <record>
      <xsl:apply-templates mode="common-properties" select="." />
      <field>
        <xsl:value-of select="datavalue/value/@numeric-id" />
      </field>
    </record>
  </xsl:template>

  <xsl:template match="mainsnak[@datatype = 'quantity']">
    <record>
      <xsl:apply-templates mode="common-properties" select="." />
      <field>
        <xsl:value-of select="datavalue/value/@amount" />
      </field>
    </record>
  </xsl:template>

  <xsl:template match="mainsnak[@datatype = 'globe-coordinate']">
    <xsl:apply-templates mode="globe-coordinate"
      select="
        datavalue/value/@latitude
      | datavalue/value/@longitude
      | datavalue/value/@altitude
      "
    />
  </xsl:template>

  <xsl:template mode="globe-coordinate" match="datavalue/value/@*[. != '']">
    <record>
      <xsl:apply-templates mode="common-properties" select="../../..">
        <xsl:with-param name="valueType" select="name(.)" />
      </xsl:apply-templates>
      <field>
        <xsl:value-of select="." />
      </field>
    </record>
  </xsl:template>

  <xsl:template match="mainsnak[@datatype = 'monolingualtext']">
    <record>
      <xsl:apply-templates mode="common-properties" select="." />
      <field>
        <xsl:value-of select="datavalue/value/@text" />
      </field>
    </record>
  </xsl:template>

  <xsl:template match="mainsnak[@datatype = 'time']">
    <record>
      <xsl:apply-templates mode="common-properties" select="." />
      <field>
        <xsl:value-of select="datavalue/value/@time" />
      </field>
    </record>
  </xsl:template>

  <!--
    'novalue' is displayed as 'no value' in HTML rendering on Wikidata,
    'somevalue' as 'unknown value'
  -->
  <xsl:template
    match="
      mainsnak[
           @snaktype = 'novalue'
        or @snaktype = 'somevalue'
      ]
    "
  >
    <record>
      <xsl:apply-templates mode="common-properties" select="." />
      <!-- leave the value empty -->
      <field />
    </record>
  </xsl:template>

  <xsl:template match="mainsnak">
    <xsl:message terminate="yes">
      <xsl:text>Error: Unsupported snak snaktype='</xsl:text>
      <xsl:value-of select="@snaktype" />
      <xsl:text>' datatype='</xsl:text>
      <xsl:value-of select="@datatype" />
      <xsl:text>' for property '</xsl:text>
      <xsl:value-of select="@property" />
      <xsl:text>'</xsl:text>
    </xsl:message>
  </xsl:template>

  <!-- disable copy of text nodes (by default) -->
  <xsl:template match="text()" />

</xsl:stylesheet>
