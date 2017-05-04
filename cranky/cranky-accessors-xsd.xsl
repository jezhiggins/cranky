<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="1.0">

  <xsl:template match="xs:element[@ref]" mode="accessors">
    <xsl:variable name="ref" select="@ref"/>

    <xsl:apply-templates select="/xs:schema/xs:element[@name=$ref]" mode="accessors"/>
  </xsl:template>

  <xsl:template match="xs:element[@type]" mode="accessors">
    <xsl:call-template name="make-accessors">
      <xsl:with-param name="name" select="@name"/>
      <xsl:with-param name="type">
        <xsl:call-template name="simple-type-lookup">
          <xsl:with-param name="type" select="@type"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xs:element[xs:complexType]" mode="accessors">
    <xsl:call-template name="make-accessors">
      <xsl:with-param name="name" select="concat(@name, '_value')"/>
      <xsl:with-param name="type">const <xsl:value-of select="@name"/>&amp;</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xs:element" mode="accessors">
    <xsl:message>----- can't deal with xs:element <xsl:value-of select="@name"/></xsl:message>
  </xsl:template>

  <xsl:template name="make-accessors">
    <xsl:param name="name"/>
    <xsl:param name="type"/>

    <xsl:value-of select="$type"/>
    <xsl:text> get_</xsl:text>
    <xsl:value-of select="$name"/>
    <xsl:text>() const;
        void set_</xsl:text>
    <xsl:value-of select="$name"/>
    <xsl:text>(</xsl:text>
    <xsl:value-of select="$type"/>
    <xsl:text> new_</xsl:text>
    <xsl:value-of select="$name"/>
    <xsl:text>);</xsl:text>    
  </xsl:template>

  <xsl:template match="*" mode="accessors">
    <xsl:apply-templates mode="accessors"/>
  </xsl:template>

</xsl:stylesheet>
