<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="1.0">

  <xsl:output method="text"/>

  <xsl:include href="cranky-accessors-xsd.xsl"/>
  <xsl:include href="cranky-member-variables-xsd.xsl"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="xs:schema">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="xs:element[xs:complexType]">
    <xsl:variable name="name" select="@name"/>

    class <xsl:value-of select="$name"/>_impl;
  
    class <xsl:value-of select="$name"/>
    {
      public:
        <xsl:value-of select="$name"/>();
        <xsl:value-of select="$name"/>(const <xsl:value-of select="$name"/> rhs);
        ~<xsl:value-of select="$name"/>();

        <xsl:value-of select="$name"/>&amp; operator=(const <xsl:value-of select="$name"/>&amp; rhs);
        bool operator==(const <xsl:value-of select="$name"/>&amp; rhs) const;

    <xsl:apply-templates mode="accessors"/>

        void emit_xml(std::ostream&amp; os) const;

      private:
        void set_impl(<xsl:value-of select="$name"/>_impl* impl);
        <xsl:value-of select="$name"/>_impl* impl_;
    } // <xsl:value-of select="@name"/>;

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
    <xsl:choose>
      <xsl:when test="$type = 'xs:string'">
        <xsl:text>const std::string&amp;</xsl:text>
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
