<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/2000/svg"
  version="1.0"
>
  <!--
  Create the list of CSS classes to position sprites in the combined image

  Input:
    XML without namespace, with the following structure,
    * lines - root element, a list of lines
    * line - element, contains a text value, the relative path to a SVG file

  Parameters:
    * IMAGE_PATH - optional, string, the path to the image sprites,
                   relative to the CSS style sheet, defaults to 'sprites.png'
    * SPRITE_CLASS - optional, string, name of the CSS class for common
                     properties of all sprites, defaults to 'sprite'
    * SPRITE_PREFIX - optional, string, prefix added to the names of the
                      CSS classes for each sprite, defaults to '' (no prefix).
                      Note: the prefix is not added to the SPRITE_CLASS name.
    * WIDTH, HEIGHT, MARGIN - see dimensions.xsl

  Output:
    The list of CSS classes to position each sprite in the combined image,
    with just the background-position property defined, set to the offsets
    computing according to the sprite position within the list.

    The name of each CSS class is set to the optional prefix from parameter
    SPRITE_PREFIX followed with the name of the file after removing the
    extension. This name is expected to contain only characters valid as a
    CSS class name, and in particular to contain no space characters, and
    no digit in first position.

    An extra class, whose name is given in parameter SPRITE_NAME, is defined
    with the shared properties of all the sprites: the relative path to the
    image, using the value of the parameter IMAGE_PATH, the background-repeat
    property, fixed to no-repeat, and the width and height of a sprite, set to
    the values of WIDTH and HEIGHT parameters respectively.

    To apply a sprite as background image, two classes shall be set to the
    element: the common class configured by SPRITE_NAME and the specific class
    for the sprite, built from the optional prefix and the file name without
    the extension.
  -->
  <xsl:import href="basename.xsl" />
  <xsl:import href="dimensions.xsl" />

  <xsl:output method="text" encoding="UTF-8" />

  <xsl:param name="IMAGE_PATH" select="'sprites.png'" />
  <xsl:param name="SPRITE_CLASS" select="'sprite'" />
  <xsl:param name="SPRITE_PREFIX" select="''" />

  <xsl:template match="lines">
    <xsl:text>.</xsl:text>
    <xsl:value-of select="$SPRITE_CLASS" />

    <xsl:text>{</xsl:text>

    <xsl:text>background-image:</xsl:text>
    <xsl:text>url(</xsl:text>
    <xsl:value-of select="$IMAGE_PATH" />
    <xsl:text>)</xsl:text>
    <xsl:text>;</xsl:text>

    <xsl:text>background-repeat:</xsl:text>
    <xsl:text>no-repeat</xsl:text>
    <xsl:text>;</xsl:text>

    <xsl:text>width:</xsl:text>
    <xsl:value-of select="$WIDTH" />
    <xsl:text>;</xsl:text>

    <xsl:text>height:</xsl:text>
    <xsl:value-of select="$HEIGHT" />
    <xsl:text>}</xsl:text>

    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="line">
    <xsl:variable name="id">
     <xsl:call-template name="basename">
      <xsl:with-param name="filename" select="." />
      <xsl:with-param name="extension" select="'.svg'" />
     </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="offset" select="count(preceding-sibling::line)" />
    <xsl:variable name="left">
      <xsl:call-template name="leftPosition">
        <xsl:with-param name="offset" select="$offset" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="top">
      <xsl:call-template name="topPosition">
        <xsl:with-param name="offset" select="$offset" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:text>.</xsl:text>
    <xsl:value-of select="$SPRITE_PREFIX" />
    <xsl:value-of select="$id" />

    <xsl:text>{</xsl:text>

    <xsl:text>background-position:</xsl:text>
    <xsl:value-of select="$left" />
    <xsl:text> </xsl:text>
    <xsl:value-of select="$top" />
    <xsl:text>}</xsl:text>
  </xsl:template>

</xsl:stylesheet>
