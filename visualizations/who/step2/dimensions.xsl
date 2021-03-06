<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
>
  <!--
  Template functions to compute various dimensions of sprite images for flags

  Parameters:
    * MAX_WIDTH - optional, number, maximum width of the sprites image
                  in pixels, defaults to 1600
                  Note: it must be less than 32,766 for display in Firefox
                  (as of Firefox 38, in 2015) and the resulting height must
                  also be less than 32,766.
                  Reference:
                  https://support.mozilla.org/en-US/questions/960717
    * WIDTH - optional, number, target width of each flag sprite in pixels,
              defaults to 360
    * HEIGHT - optional, number, target height of the each flag sprite
               in pixels, defaults to 360
    * MARGIN - optional, number, space left between sprite images
               (both vertically and horizontally) in pixels, defaults to 10
  -->

  <xsl:param name="MAX_WIDTH" select="3690" />
  <xsl:param name="WIDTH" select="360" />
  <xsl:param name="HEIGHT" select="360" />
  <xsl:param name="MARGIN" select="10" />

  <xsl:variable name="MAX_SPRITES_PER_ROW"
    select="floor( ($MAX_WIDTH + $MARGIN) div ($WIDTH + $MARGIN) )"
  />

  <!--
  Compute the total width of the combined sprites image

  Parameter:
    * count - number, total number of images

  Returns:
    number, the total width in pixels of the sprites image,
    which is computed as the number of sprites per row
    multiplied by the WIDTH and MARGIN, minus the MARGIN
    after the last sprite.
  -->
  <xsl:template name="totalWidth">
    <xsl:param name="count" />

    <xsl:variable name="spritesPerRow">
      <xsl:choose>
        <xsl:when test="$count &lt; $MAX_SPRITES_PER_ROW">
          <xsl:value-of select="$count" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$MAX_SPRITES_PER_ROW" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of
      select="($WIDTH + $MARGIN) * $spritesPerRow - $MARGIN"
    />
  </xsl:template>

  <!--
  Compute the total height of the combined sprites image

  Parameter:
    * count - number, total number of images

  Returns:
    number, the total height in pixels of the sprites image,
    which is computed as the number of rows multiplied by
    the HEIGHT and MARGIN, minus the MARGIN after the last row.
  -->
  <xsl:template name="totalHeight">
    <xsl:param name="count" />

    <xsl:variable name="rows"
      select="ceiling( $count div $MAX_SPRITES_PER_ROW )"
    />
    <xsl:value-of select="($HEIGHT + $MARGIN) * $rows - $MARGIN" />
  </xsl:template>

  <!--
  Get the left position of a sprite image in the combined image

  Parameter:
    number, the offset of the sprite image in the total number of images,
    starting from 0
    Note: The offset is the number of images before the current sprite image.

  Returns:
    number, the position of the sprite image from the left, in pixels,
    computed by multiplying the number of preceding sprites in the row
    with the WIDTH and MARGIN.

  -->
  <xsl:template name="leftPosition">
    <xsl:param name="offset" />

    <xsl:variable name="spritesBeforeInSameRow"
      select="$offset mod $MAX_SPRITES_PER_ROW"
    />
    <xsl:value-of select="$spritesBeforeInSameRow * ($WIDTH + $MARGIN)" />
  </xsl:template>

  <!--
  Get the top position of a sprite image in the combined image

  Parameter:
    number, the offset of the sprite image in the total number of images,
    starting from 0
    Note: The offset is the number of images before the current sprite image.

  Returns:
    number, the position of the sprite image from the top, in pixels,
    computed by multiplying the number of preceding rows by the HEIGHT
    and MARGIN.
  -->
  <xsl:template name="topPosition">
    <xsl:param name="offset" />

    <xsl:variable name="rowsBefore"
      select="floor( $offset div $MAX_SPRITES_PER_ROW )"
    />
    <xsl:value-of select="$rowsBefore * ($HEIGHT + $MARGIN)" />
  </xsl:template>

  <!--
  Get the width of the image resized to fit within target box

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
  Get the height of the image resized to fit within target box

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

  <!--
  Add the 'px' unit to any non-zero value

  Parameter:
    * value - number, the value in pixels

  Returns:
    string, the same value, with the unit 'px' added,
    unless the value is zero
  -->
  <xsl:template name="toPixels">
    <xsl:param name="value" />

    <xsl:choose>
      <xsl:when test="$value = 0">
        <xsl:value-of select="$value" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($value,'px')" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
  Compute the offset to center a resized sprite within target box

  Parameters:
    * length - number, the resized dimension
    * within - number, the target dimension

  Returns:
    number, the offset computed from half of the difference between
    the target dimension and the resized dimension.

  Notes:
  The same template function can be used for both width and height.
  The 'length' value is expected to be smaller than or equal to the
  value of the parameter 'within' for target dimension.
  -->
  <xsl:template name="centerShift">
    <xsl:param name="length" />
    <xsl:param name="within" />

    <xsl:value-of select="($within - $length) div 2" />
  </xsl:template>

</xsl:stylesheet>
