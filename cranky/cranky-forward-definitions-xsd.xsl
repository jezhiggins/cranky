<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="1.0">

  <xsl:template match="xs:element[@ref]" mode="forward-definitions">
    <xsl:variable name="ref" select="@ref"/>
    <xsl:apply-templates select="/xs:schema/xs:element[@name=$ref]" mode="forward-definitions"/>
  </xsl:template>

  <xsl:template match="xs:element[xs:complexType]" mode="forward-definitions">
    class <xsl:value-of select="@name"/>;
  </xsl:template>

  <xsl:template match="*" mode="forward-definitions">
    <xsl:apply-templates mode="forward-definitions"/>
  </xsl:template>
</xsl:stylesheet>
