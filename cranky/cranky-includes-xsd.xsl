<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="1.0">

  <xsl:template match="xs:element[@ref]" mode="includes">
    <xsl:variable name="ref" select="@ref"/>
    <xsl:apply-templates select="/xs:schema/xs:element[@name=$ref]" mode="includes"/>
  </xsl:template>

  <xsl:template match="xs:element[xs:complexType]" mode="includes">
    #include "<xsl:value-of select="@name"/>.hpp"
  </xsl:template>

  <xsl:template match="*" mode="includes">
    <xsl:apply-templates mode="includes"/>
  </xsl:template>
</xsl:stylesheet>
