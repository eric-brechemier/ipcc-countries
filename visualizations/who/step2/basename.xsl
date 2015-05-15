<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
>
  <!--
  Extract the name of the file from its path, without the extension

  Parameters:
    * filename - string, the path of the file
    * extension - optional, string, the extension to remove, defaults to ''

  Returns:
    string, the base file name, without the extension

  Note:
  This function is similar to the POSIX Shell utility of the same name.
  -->
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

</xsl:stylesheet>
