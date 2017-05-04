<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="1.0">

  <!-- GETTERS -->
  <xsl:template match="xs:element[@ref]" mode="get-accessors">
    <xsl:variable name="ref" select="@ref"/>

    <xsl:apply-templates select="/xs:schema/xs:element[@name=$ref]" mode="get-accessors"/>
  </xsl:template>

  <xsl:template match="xs:attribute" mode="get-accessors">
    <xsl:call-template name="make-get-accessors">
      <xsl:with-param name="name" select="@name"/>
      <xsl:with-param name="type">
        <xsl:call-template name="simple-type-lookup">
          <xsl:with-param name="type" select="@type"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xs:element[@type]" mode="get-accessors">
    <xsl:call-template name="make-get-accessors">
      <xsl:with-param name="name" select="@name"/>
      <xsl:with-param name="type">
        <xsl:call-template name="simple-type-lookup">
          <xsl:with-param name="type" select="@type"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xs:element[xs:complexType]" mode="get-accessors">
    <xsl:call-template name="make-get-accessors">
      <xsl:with-param name="name" select="@name"/>
      <xsl:with-param name="type">const <xsl:value-of select="@name"/>&amp;</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xs:element" mode="get-accessors">
    <xsl:message>----- can't deal with xs:element <xsl:value-of select="@name"/></xsl:message>
  </xsl:template>

  <xsl:template name="make-get-accessors">
    <xsl:param name="name"/>
    <xsl:param name="type"/>

    <xsl:text>    </xsl:text>
    <xsl:value-of select="$type"/>
    <xsl:text> get_</xsl:text>
    <xsl:value-of select="$name"/>
    <xsl:text>() const;
    </xsl:text>
  </xsl:template>

  <xsl:template match="*" mode="get-accessors">
    <xsl:apply-templates mode="get-accessors"/>
  </xsl:template>

  <!-- SETTERS -->
  <xsl:template match="xs:element[@ref]" mode="set-accessors">
    <xsl:variable name="ref" select="@ref"/>

    <xsl:apply-templates select="/xs:schema/xs:element[@name=$ref]" mode="set-accessors"/>
  </xsl:template>

  <xsl:template match="xs:attribute" mode="set-accessors">
    <xsl:call-template name="make-set-accessors">
      <xsl:with-param name="name" select="@name"/>
      <xsl:with-param name="type">
        <xsl:call-template name="simple-type-lookup">
          <xsl:with-param name="type" select="@type"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xs:element[@type]" mode="set-accessors">
    <xsl:call-template name="make-set-accessors">
      <xsl:with-param name="name" select="@name"/>
      <xsl:with-param name="type">
        <xsl:call-template name="simple-type-lookup">
          <xsl:with-param name="type" select="@type"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xs:element[xs:complexType]" mode="set-accessors">
    <xsl:call-template name="make-set-accessors">
      <xsl:with-param name="name" select="@name"/>
      <xsl:with-param name="type">const <xsl:value-of select="@name"/>&amp;</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xs:element" mode="set-accessors">
    <xsl:message>----- can't deal with xs:element <xsl:value-of select="@name"/></xsl:message>
  </xsl:template>

  <xsl:template name="make-set-accessors">
    <xsl:param name="name"/>
    <xsl:param name="type"/>

    <xsl:text>    void set_</xsl:text>
    <xsl:value-of select="$name"/>
    <xsl:text>(</xsl:text>
    <xsl:value-of select="$type"/>
    <xsl:text> new_</xsl:text>
    <xsl:value-of select="$name"/>
    <xsl:text>);
    </xsl:text>    
  </xsl:template>

  <xsl:template match="*" mode="set-accessors">
    <xsl:apply-templates mode="set-accessors"/>
  </xsl:template>

</xsl:stylesheet>
