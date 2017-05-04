<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="1.0">

  <xsl:template name="generate-implementation">
    <xsl:param name="name"/>

    /* 
     * This source file was automatically generated from 
     * an XML Schema.  You probably don't want to edit it.
     */
    
    <xsl:call-template name="implementation-class">
      <xsl:with-param name="name" select="$name"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="implementation-class">
    <xsl:param name="name"/>
    class <xsl:value-of select="$name"/>_impl
    {
      public:
        <xsl:value-of select="$name"/>_impl() :
          <xsl:apply-templates mode="impl_member_initialisation"/>
          ref_count(0)
        {
        } //

        //////////////////////////
        // instance variables

        //////////////////////////
        // ref count
        void add_ref() { ++ref_count; }
        void remove_ref() { if(--ref_count == 0) delete this; }

      private:
        unsigned int ref_count;

        // no impl
        <xsl:value-of select="$name"/>_impl(const <xsl:value-of select="$name"/>_impl&amp;);
        <xsl:value-of select="$name"/>_impl&amp; operator=(const <xsl:value-of select="$name"/>_impl&amp;);
        bool operator==(const <xsl:value-of select="$name"/>_impl&amp;) const;
    } // class <xsl:value-of select="$name"/>_impl
  </xsl:template>

  <xsl:template match="xs:element[@ref]" mode="impl_member_initialisation">
    <xsl:variable name="ref" select="@ref"/>
    <xsl:apply-templates select="/xs:schema/xs:element[@name=$ref]" mode="impl_member_initialisation"/>
  </xsl:template>

  <xsl:template match="xs:element[@type]|xs:element[xs:complexType]|xs:attribute" mode="impl_member_initialisation">
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
 
   <xsl:value-of select="@name"/>
    <xsl:if test="$multiple">
      <xsl:text>_collection</xsl:text>
    </xsl:if>
    <xsl:text>_(</xsl:text>
    <xsl:if test="$type = 'int' and not($multiple)">
      <xsl:text>0</xsl:text>
    </xsl:if>
    <xsl:text>),</xsl:text>
    <xsl:if test="$optional">
      <xsl:text>is_</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>_set_(false),</xsl:text>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
