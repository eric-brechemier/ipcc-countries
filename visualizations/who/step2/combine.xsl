<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/2000/svg"
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  exclude-result-prefixes="svg"
  version="1.0"
>
  <!--
  Combine a list of SVG files into a single SVG file

  Input:
    XML without namespace, with the following structure,
    * lines - root element, a list of lines
    * line - element, contains a text value, the relative path to a SVG file

  Output:
    a single SVG file which contains a defs element with a copy of
    the svg element for each flag from the corresponding file.

    Each svg element in defs is assigned a unique identifier based on
    the file name (with parent path and extension removed), which is
    also used as prefix to make id attributes (and references) unique
    in the context of the combined SVG document.
  -->

  <xsl:output method="xml" encoding="UTF-8" />

  <xsl:template match="lines">
    <svg version="1.1">
      <defs>
        <xsl:apply-templates />
      </defs>
    </svg>
  </xsl:template>

  <xsl:template name="basename">
    <xsl:param name="filename" />
    <xsl:param name="extension" select="''" />

    <xsl:variable name="separator" select="'/'" />
    <xsl:choose>
      <xsl:when test="contains($filename,$separator)">
        <xsl:call-template name="basename">
          <xsl:with-param name="filename"
            select="substring-after($filename,$separator)"
          />
          <xsl:with-param name="extension" select="$extension" />
         </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring-before($filename,$extension)" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="line">
    <xsl:apply-templates mode="copy" select="document(.)/svg:svg">
      <xsl:with-param name="id">
       <xsl:call-template name="basename">
        <xsl:with-param name="filename" select="." />
        <xsl:with-param name="extension" select="'.svg'" />
       </xsl:call-template>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template mode="copy" match="svg:svg">
    <xsl:param name="id" />
    <xsl:copy>
      <xsl:attribute name="id">
        <xsl:value-of select="$id" />
      </xsl:attribute>
      <xsl:apply-templates mode="copy" select="@* | node()">
        <xsl:with-param name="prefix" select="concat($id,'-')" />
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="copy" match="@id">
    <xsl:param name="prefix" />
    <xsl:attribute name="id">
      <xsl:value-of select="concat($prefix,.)" />
    </xsl:attribute>
  </xsl:template>

  <xsl:template mode="copy" match="@xlink:href[ starts-with(.,'#') ]">
    <xsl:param name="prefix" />
    <xsl:attribute name="xlink:href">
      <xsl:value-of select="concat('#',$prefix,substring-after(.,'#'))" />
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="replace">
    <xsl:param name="all" />
    <xsl:param name="with" />
    <xsl:param name="in" />

    <xsl:choose>
      <xsl:when test="contains($in,$all)">
        <xsl:value-of select="substring-before($in,$all)" />
        <xsl:value-of select="$with" />
        <xsl:call-template name="replace">
          <xsl:with-param name="all" select="$all" />
          <xsl:with-param name="with" select="$with" />
          <xsl:with-param name="in" select="substring-after($in,$all)" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$in" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="copy" match="@*[ contains(.,'url(#') ]">
    <xsl:param name="prefix" />
    <xsl:attribute name="{name()}" namespace="{namespace-uri()}">
      <xsl:call-template name="replace">
        <xsl:with-param name="all" select="'url(#'" />
        <xsl:with-param name="with" select="concat('url(#',$prefix)" />
        <xsl:with-param name="in" select="." />
      </xsl:call-template>
    </xsl:attribute>
  </xsl:template>

  <xsl:template mode="copy" match="@* | node()">
    <xsl:param name="prefix" />
    <xsl:copy>
      <xsl:apply-templates mode="copy" select="@* | node()">
        <xsl:with-param name="prefix" select="$prefix" />
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
