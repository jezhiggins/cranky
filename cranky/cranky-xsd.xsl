<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="1.1">

  <xsl:output method="text"/>

  <xsl:param name="output-dir">output</xsl:param>

  <xsl:include href="cranky-generate-header-xsd.xsl"/>
  <xsl:include href="cranky-member-variables-xsd.xsl"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="xs:schema">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="xs:element[xs:complexType]">
    <xsl:variable name="name" select="@name"/>

    <xsl:document href="{$output-dir}/{$name}.hpp">
      <xsl:call-template name="generate-header">
        <xsl:with-param name="name" select="$name"/>
      </xsl:call-template>
    </xsl:document>

    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="xs:element[@type]">
    <!-- eat it, it is inlined in the class -->
  </xsl:template>

  <xsl:template match="*">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="simple-type-lookup">
    <xsl:param name="type"/>
    <xsl:param name="no-cv-qualifiers"/>
    <xsl:choose>
      <xsl:when test="$type = 'xs:string' or $type = 'xs:ID'">
        <xsl:choose>
          <xsl:when test="$no-cv-qualifiers">
            <xsl:text>std::string</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>const std::string&amp;</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$type = 'xs:int'">
        <xsl:text>int</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          Don't understand <xsl:value-of select="$type"/> in element <xsl:value-of select="@name"/>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
