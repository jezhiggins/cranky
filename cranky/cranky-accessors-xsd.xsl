<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="1.0">

  <xsl:template match="xs:element[@ref]" mode="accessors">
    <xsl:variable name="ref" select="@ref"/>

    <xsl:apply-templates select="/xs:schema/xs:element[@name=$ref]" mode="accessors"/>
  </xsl:template>

  <xsl:template match="xs:element[@type]|xs:element[xs:complexType]|xs:attribute" mode="accessors">
    <xsl:variable name="optional" select="@minOccurs = '0' and (not(@maxOccurs) or (@maxOccurs = '1'))"/>
    <xsl:variable name="multiple" select="@maxOccurs"/>
    <xsl:variable name="type">
      <xsl:choose>
        <xsl:when test="@type">
          <xsl:call-template name="simple-type-lookup">
            <xsl:with-param name="type" select="@type"/>
            <xsl:with-param name="no-cv-qualifiers" select="$multiple"/>
          </xsl:call-template>          
        </xsl:when>
        <xsl:when test="xs:complexType">
          <xsl:value-of select="concat('const ', @name, '&amp;')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            Cannot determine type of <xsl:value-of select="@name"/>
          </xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:call-template name="make-accessors">
      <xsl:with-param name="name" select="@name"/>
      <xsl:with-param name="type" select="$type"/>
      <xsl:with-param name="optional" select="$optional"/>
      <xsl:with-param name="multiple" select="$multiple"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xs:element" mode="accessors">
    <xsl:message>----- can't deal with xs:element <xsl:value-of select="@name"/></xsl:message>
  </xsl:template>

  <xsl:template match="*" mode="accessors">
    <xsl:apply-templates mode="accessors"/>
  </xsl:template>

  <xsl:template name="make-accessors">
    <xsl:param name="name"/>
    <xsl:param name="type"/>
    <xsl:param name="optional"/>
    <xsl:param name="multiple"/>

    <xsl:variable name="true-type">
      <xsl:choose>
        <xsl:when test="$multiple">
          <xsl:text>const std::vector&lt;</xsl:text>
          <xsl:value-of select="$type"/>
          <xsl:text>&gt;&amp;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$type"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:call-template name="make-get-accessors">
      <xsl:with-param name="name" select="$name"/>
      <xsl:with-param name="type" select="$true-type"/>
      <xsl:with-param name="optional" select="$optional"/>
      <xsl:with-param name="multiple" select="$multiple"/>
    </xsl:call-template>
    <xsl:call-template name="make-set-accessors">
      <xsl:with-param name="name" select="$name"/>
      <xsl:with-param name="type" select="$type"/>
      <xsl:with-param name="optional" select="$optional"/>
      <xsl:with-param name="multiple" select="$multiple"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="make-get-accessors">
    <xsl:param name="name"/>
    <xsl:param name="type"/>
    <xsl:param name="optional"/>

    <xsl:text>    </xsl:text>
    <xsl:value-of select="$type"/>
    <xsl:text> get_</xsl:text>
    <xsl:value-of select="$name"/>
    <xsl:text>() const;
    </xsl:text>
    <xsl:if test="$optional">
      <xsl:text>    bool is_</xsl:text>
      <xsl:value-of select="$name"/>
      <xsl:text>_set() const;
    </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="make-set-accessors">
    <xsl:param name="name"/>
    <xsl:param name="type"/>
    <xsl:param name="optional"/>

    <xsl:text>    void set_</xsl:text>
    <xsl:value-of select="$name"/>
    <xsl:text>(</xsl:text>
    <xsl:value-of select="$type"/>
    <xsl:text> new_</xsl:text>
    <xsl:value-of select="$name"/>
    <xsl:text>);
    </xsl:text>
    <xsl:if test="$optional">
      <xsl:text>    void reset_</xsl:text>
      <xsl:value-of select="$name"/>
      <xsl:text>();
    </xsl:text>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
