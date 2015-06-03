<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/2000/svg"
  version="1.0"
>
  <!--
  Utility to format a number as an English name

  Note: this feature has extended support in XSLT 2.0 using xsl:number;
  the present utility defines an implementation limited to numbers
  from zero to ten, for use in XSLT 1.0. Numbers higher than then
  are left as digits.
  -->

  <!--
  Convert a number to English words: zero, one, two, ... up to ten
  Numbers higher than ten are left in digits: 11, 12, ...

  Parameter:
    number - number, the number to convert

  Returns:
    string, the number converted to English, from zero to ten,
    or left as is otherwise.
  -->
  <xsl:template name="format-english-number">
    <xsl:param name="number" />
    <xsl:choose>
      <xsl:when test="$number = 0">zero</xsl:when>
      <xsl:when test="$number = 1">one</xsl:when>
      <xsl:when test="$number = 2">two</xsl:when>
      <xsl:when test="$number = 3">three</xsl:when>
      <xsl:when test="$number = 4">four</xsl:when>
      <xsl:when test="$number = 5">five</xsl:when>
      <xsl:when test="$number = 6">six</xsl:when>
      <xsl:when test="$number = 7">seven</xsl:when>
      <xsl:when test="$number = 8">eight</xsl:when>
      <xsl:when test="$number = 9">nine</xsl:when>
      <xsl:when test="$number = 10">ten</xsl:when>
      <xsl:otherwise>
        <!-- leave number unchanged -->
        <xsl:value-of select="$number" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
