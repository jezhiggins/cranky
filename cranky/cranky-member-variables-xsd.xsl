<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="1.0">

  <xsl:template match="xs:complexType" mode="member-variables">
    <xsl:apply-templates mode="member-variables"/>
  </xsl:template>

  <xsl:template match="xs:element[@type='xs:string']" mode="member-variables">
    <xsl:text>std::string </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>_;</xsl:text>
  </xsl:template>

  <xsl:template match="xs:element[@type='xs:int']" mode="member-variables">
    <xsl:text>int </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>_;</xsl:text>
  </xsl:template>

  <xsl:template match="xs:element" mode="member-variables">
    <xsl:message>----- can't deal with xs:element <xsl:value-of select="@name"/></xsl:message>
  </xsl:template>

</xsl:stylesheet>
