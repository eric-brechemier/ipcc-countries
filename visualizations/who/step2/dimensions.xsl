<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
>
  <!--
  Template functions to compute various dimensions of sprite images for flags

  Parameters:
    * WIDTH - optional, number, target width of each flag sprite in pixels,
              defaults to 360
    * HEIGHT - optional, number, target height of the each flag sprite
               in pixels, defaults to 360
    * MARGIN - optional, number, horizontal space left between sprite images
               (laid out horizontally) in pixels, defaults to 10
  -->

  <xsl:param name="WIDTH" select="360" />
  <xsl:param name="HEIGHT" select="360" />
  <xsl:param name="MARGIN" select="10" />

  <!--
  Compute the total width of the combined sprites image

  Parameter:
    * count - number, total number of images

  Returns:
    number, the width in pixels, computed by multiplying the total number of
    images by the width of each image + margin (omitted after last image).
  -->
  <xsl:template name="totalWidth">
    <xsl:param name="count" />

    <xsl:value-of select="$WIDTH * $count + $MARGIN * (1 - $count)" />
  </xsl:template>

  <!--
  Compute the total height of the combined sprites image

  Parameter:
    * count - number, total number of images

  Returns:
    number, the height in pixels, currently fixed to HEIGHT
  -->
  <xsl:template name="totalHeight">
    <xsl:param name="count" />

    <xsl:value-of select="$HEIGHT" />
  </xsl:template>

  <!--
  Get the left position of a sprite image in the combined image

  Parameter:
    number, the offset of the sprite image in the total number of images,
    starting from 0

  Returns:
    number, the position of the sprite image from the left, in pixels,
    computed by multiplying the offset by the WIDTH and MARGIN.

  Note:
  The offset is the number of images before the current sprite image.
  -->
  <xsl:template name="leftPosition">
    <xsl:param name="offset" />

    <xsl:value-of select="($WIDTH + $MARGIN) * $offset" />
  </xsl:template>

  <!--
  Get the top position of a sprite image in the combined image

  Parameter:
    number, the offset of the sprite image in the total number of images,
    starting from 0

  Returns:
    number, the position of the sprite image from the top, in pixels,
    currently fixed to 0

  Note:
  The offset is the number of images before the current sprite image.
  -->
  <xsl:template name="topPosition">
    <xsl:param name="offset" />

    <xsl:value-of select="0" />
  </xsl:template>

  <!--
  Get the width of the image resized to fit within the sprite

  Parameters:
    * width - number, the width of the original image, in pixels
    * height - number, the height of the original image, in pixels

  Returns:
    number, the width of the image in pixels after resizing it to fit
    either the full width or the full height without overflow

  Note:
  The picture ratio is preserved.
  -->
  <xsl:template name="resizeWidth">
    <xsl:param name="width" />
    <xsl:param name="height" />

    <xsl:choose>
      <xsl:when test="$width div $height >= $WIDTH div $HEIGHT">
        <xsl:value-of select="$WIDTH" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$width * $HEIGHT div $height" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
  Get the height of the image resized to fit within the sprite

  Parameters:
    * width - number, the width of the original image, in pixels
    * height - number, the height of the original image, in pixels

  Returns:
    number, the height of the image in pixels after resizing it to fit
    either the full width or the full height without overflow

  Note:
  The picture ratio is preserved.
  -->
  <xsl:template name="resizeHeight">
    <xsl:param name="width" />
    <xsl:param name="height" />

    <xsl:choose>
      <xsl:when test="$width div $height >= $WIDTH div $HEIGHT">
        <xsl:value-of select="$height * $WIDTH div $width" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$HEIGHT" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
  Convert a value to pixels, removing the unit 'px' if any

  Parameter:
    * value - string, the value with an optional 'px' unit

  Returns:
    number, the same value, without the optional 'px' unit
  -->
  <xsl:template name="fromPixels">
    <xsl:param name="value" />

    <xsl:choose>
      <xsl:when test="contains($value,'px')">
        <xsl:value-of select="substring-before($value,'px')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$value" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
