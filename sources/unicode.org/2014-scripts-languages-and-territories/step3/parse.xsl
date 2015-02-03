<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xhtml"
  version="1.0"
>

  <xsl:output mode="text" encoding="UTF-8" omit-xml-declaration="yes" />

  <xsl:variable name="NEWLINE" select="'&#xA;'" />
  <xsl:variable name="QUOTE">"</xsl:variable>
  <xsl:variable name="COMMA" select="','" />

  <!-- a character which does not appear in the data -->
  <xsl:variable name="QUEUE_SEPARATOR" select="'|'" />

  <xsl:template match="/">
    <!-- print headers -->
    <xsl:text>Sample Char</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Script Name</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Script Code</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Target?</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Language Name</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Language's Native Name</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Language Code</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Target?</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Territory Name</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Territory's Native Name</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Territory Code</xsl:text>
    <xsl:value-of select="$NEWLINE" />

    <!-- select the row of data, skipping header row in first position -->
    <xsl:apply-templates
      select="
        /xhtml:html
        /xhtml:body
        /xhtml:div[@class='body'][1]
        /xhtml:div[2]
        /xhtml:table
        /xhtml:tr[2]
      "
    />
  </xsl:template>

  <xsl:template match="xhtml:tr">
    <!--
      queue of rowspan+CSV values for columns
      on the left on next row;
      produced while processing current row,
      for use as rightQueue in next row
    -->
    <xsl:param name="leftQueue" select="''" />
    <!--
      queue of rowspan+CSV values for columns
      just above and on the right on previous row;
      consumed while processing current row;
      the rowspan is found first, optionally
      followed with the CSV value for the column,
      when the rowspan differs from 1.
      The rowspan value may be empty;
      this occurs while processing the first row,
      and anytime the width of the current row
      is larger than the width of the previous row.
    -->
    <xsl:param name="rightQueue" select="''" />
    <!--
      position of the next cell to read in current row
    -->
    <xsl:param name="cellPosition" select="1" />

    <!-- list of th/td in current row -->
    <xsl:variable name="cells" select="xhtml:th | xhtml:td" />

    <!-- the cell at current position -->
    <xsl:variable name="currentCell"
      select="$cells[position() = $cellPosition]"
    />

    <!--
      the queue starts with the rowspan
      for current column in previous row
    -->
    <xsl:variable name="previousRowSpan"
      select="substring-before($rightQueue,$QUEUE_SEPARATOR)"
    />
    <xsl:variable name="rightQueueAfterRowSpan"
      select="substring-after($rightQueue,$QUEUE_SEPARATOR)"
    />

    <xsl:variable name="hasPreviousRowSpan"
      select="
            $previousRowSpan != ''
        and $previousRowSpan != 1
      "
    />

    <xsl:variable name="previousCsvValue">
      <xsl:if test="$hasPreviousRowSpan">
        <xsl:value-of
          select="substring-before($rightQueueAfterRowSpan,$QUEUE_SEPARATOR)"
        />
      </xsl:if>
    </xsl:variable>

    <!-- update right queue after reading -->
    <xsl:variable name="updatedRightQueue">
      <xsl:choose>
        <xsl:when test="$hasPreviousRowSpan">
          <xsl:value-of
            select="substring-after($rightQueueAfterRowSpan,$QUEUE_SEPARATOR)"
          />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$rightQueueAfterRowSpan" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="isEndOfLine"
      select="
        $cellPosition &gt;= count($cells)
        and string-length($updatedRightQueue) = 0
      "
    />

    <xsl:message>
      <xsl:value-of select="concat('Has Row Span?: ',$hasPreviousRowSpan,'&#xA;')" />
      <xsl:value-of select="concat('Cell Position: ',$cellPosition,'&#xA;')" />
      <xsl:value-of select="concat('Cell Value: ',$currentCell,'&#xA;')" />
      <xsl:value-of select="concat('Is End of Line?: ',$isEndOfLine,'&#xA;')" />
    </xsl:message>

    <!--
      CSV value, copied from above cell with rowSpan
      or read in the cell at current position
    -->
    <xsl:variable name="csvValue">
      <xsl:choose>
        <xsl:when test="$hasPreviousRowSpan">
          <!-- read the value from the 'right' queue -->
          <xsl:value-of select="$previousCsvValue" />
        </xsl:when>
        <!-- read the value from current cell -->
        <xsl:otherwise>
          <xsl:call-template name="csvField">
            <xsl:with-param name="text" select="$currentCell" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- output CSV value -->
    <xsl:value-of disable-output-escaping="yes" select="$csvValue" />

    <xsl:message>
      <xsl:text>CSV Value: </xsl:text>
      <xsl:value-of select="$csvValue" />
      <xsl:value-of select="$NEWLINE" />
    </xsl:message>

    <!-- output CSV separator -->
    <xsl:choose>
      <xsl:when test="$isEndOfLine">
        <xsl:value-of select="$NEWLINE" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$COMMA" />
      </xsl:otherwise>
    </xsl:choose>

    <!-- update the rowspan -->
    <xsl:variable name="updatedRowSpan">
      <xsl:choose>
        <xsl:when test="$previousRowSpan &gt; 1">
          <!-- decrement rowSpan -->
          <xsl:value-of select="$previousRowSpan - 1" />
        </xsl:when>
        <xsl:when test="$previousRowSpan = 0">
          <!-- cell with rowspan='0' extends to the last row of the table -->
          <xsl:value-of select="$previousRowSpan" />
        </xsl:when>
        <xsl:when test="$currentCell/@rowspan != 1">
          <xsl:value-of select="$currentCell/@rowspan" />
        </xsl:when>
        <xsl:otherwise>
          <!-- default value -->
          <xsl:value-of select="1" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- update the cell position -->
    <xsl:variable name="updatedCellPosition">
      <xsl:choose>
        <xsl:when test="$hasPreviousRowSpan">
          <!-- stay on current cell until an unoccupied position is reached -->
          <xsl:value-of select="$cellPosition" />
        </xsl:when>
        <xsl:otherwise>
          <!-- increment cell position -->
          <xsl:value-of select="$cellPosition + 1" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- write rowspan and optionally value in updated left queue -->
    <xsl:variable name="updatedLeftQueue">
      <xsl:choose>
        <xsl:when test="$updatedRowSpan = 1">
          <!-- store rowspan only -->
          <xsl:value-of
            select="concat( $leftQueue, $updatedRowSpan, $QUEUE_SEPARATOR )"
          />
        </xsl:when>
        <xsl:otherwise>
          <!-- store rowspan followed with CSV value -->
          <xsl:value-of select="
              concat(
                $leftQueue,
                $updatedRowSpan,
                $QUEUE_SEPARATOR,
                $csvValue,
                $QUEUE_SEPARATOR
              )
            "
          />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:message>
      <xsl:text>Updated Cell Position: </xsl:text>
      <xsl:value-of select="$updatedCellPosition" />
      <xsl:value-of select="$NEWLINE" />
      <xsl:text>Updated Row Span: </xsl:text>
      <xsl:value-of select="$updatedRowSpan" />
      <xsl:value-of select="$NEWLINE" />
      <xsl:text>Updated Left Queue: </xsl:text>
      <xsl:value-of select="$updatedLeftQueue" />
      <xsl:value-of select="$NEWLINE" />
      <xsl:text>Updated Right Queue: </xsl:text>
      <xsl:value-of select="$updatedRightQueue" />
      <xsl:value-of select="$NEWLINE" />
    </xsl:message>

    <xsl:message>
      <xsl:choose>
        <xsl:when test="$isEndOfLine">
          <xsl:text>===================================&#xA;&#xA;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~&#xA;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:message>

    <!-- recursion -->
    <xsl:choose>
      <xsl:when test="$isEndOfLine">
        <!-- advance to next row -->
        <xsl:apply-templates select="following-sibling::xhtml:tr[1]">
          <xsl:with-param name="rightQueue" select="$updatedLeftQueue" />
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <!-- advance to next column on current row -->
        <xsl:apply-templates select=".">
          <xsl:with-param name="leftQueue" select="$updatedLeftQueue" />
          <xsl:with-param name="rightQueue" select="$updatedRightQueue" />
          <xsl:with-param name="cellPosition" select="$updatedCellPosition" />
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="csvField">
    <xsl:param name="text" />

    <xsl:choose>
      <xsl:when test="contains($text,$COMMA)">
        <xsl:value-of select="$QUOTE" />
        <!--
          NOTE: this particular input does not contain any quote to escape
        -->
        <xsl:value-of select="$text" />
        <xsl:value-of select="$QUOTE" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
