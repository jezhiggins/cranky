<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="1.0">

  <xsl:include href="cranky-accessors-xsd.xsl"/>
  <xsl:include href="cranky-forward-definitions-xsd.xsl"/>

  <xsl:template name="generate-header">
    <xsl:param name="name"/>

    #ifndef CRANKY_GENERATED_<xsl:value-of select="$name"/>_HPP
    #define CRANKY_GENERATED_<xsl:value-of select="$name"/>_HPP

    /*
     * This header file was automatically generated from an 
     * an XML Schema.  You probably don't want to edit it.
     */

    <xsl:call-template name="includes">
      <xsl:with-param name="name" select="$name"/>
    </xsl:call-template>

    <xsl:call-template name="class-definition">
      <xsl:with-param name="name" select="$name"/>
    </xsl:call-template>

    <xsl:call-template name="class-factory-definition">
      <xsl:with-param name="name" select="$name"/>
    </xsl:call-template>

    #endif // CRANKY_GENERATED_<xsl:value-of select="$name"/>_HPP
  </xsl:template>

  <xsl:template name="includes">
    <xsl:param name="name"/>

    #include &lt;string&gt;
    #include &lt;vector&gt;
    #include &lt;SAX/XMLReader.h&gt;
    #include &lt;SAX/helpers/DefaultHander.h&gt;

    <xsl:apply-templates mode="forward-definitions"/>    
  </xsl:template>

  <xsl:template name="class-definition">
    <xsl:param name="name"/>
    class <xsl:value-of select="$name"/>_impl;
  
    class <xsl:value-of select="$name"/>
    {
      public:
        <xsl:value-of select="$name"/>();
        <xsl:value-of select="$name"/>(const <xsl:value-of select="$name"/>&amp; rhs);
        ~<xsl:value-of select="$name"/>();

        <xsl:value-of select="$name"/>&amp; operator=(const <xsl:value-of select="$name"/>&amp; rhs);
        bool operator==(const <xsl:value-of select="$name"/>&amp; rhs) const;

        ///////////////////
        // getters
    <xsl:apply-templates mode="get-accessors"/>

        ///////////////////
        // setters
    <xsl:apply-templates mode="set-accessors"/>

        void emit_xml(std::ostream&amp; os) const;

      private:
        void set_impl(<xsl:value-of select="$name"/>_impl* impl);
        <xsl:value-of select="$name"/>_impl* impl_;
    }; // <xsl:value-of select="$name"/>
  </xsl:template>

  <xsl:template name="class-factory-definition">
    <xsl:param name="name"/>

    <xsl:variable name="this" select="//xs:element[@name=$name]"/>
    <xsl:variable name="is-root" select="not(boolean(//xs:element[@ref=$name] | $this/ancestor::xs:element))"/>
    <xsl:variable name="h-c-c">
      <xsl:call-template name="has-complex-content">
        <xsl:with-param name="this" select="$this"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="has-complex-content" select="boolean($h-c-c != '')"/>

    class <xsl:value-of select="$name"/>_factory : public SAX::DefaultHandler
    {
    <xsl:if test="$is-root">
      public:
        static <xsl:value-of select="$name"/> read(SAX::InputSource&amp; is);
    </xsl:if>

      private:
        <xsl:value-of select="$name"/>_factory(SAX::XMLReader&amp; reader);
        ~<xsl:value-of select="$name"/>_factory();

        const <xsl:value-of select="$name"/>&amp; get_<xsl:value-of select="$name"/>() const;
        
        virtual void startElement(const std::string&amp; namespaceURI, 
                                  const std::string&amp; localName, 
                                  const std::string&amp; qName, 
                                  const SAX::Attributes&amp; atts);
        virtual void endElement(const std::string&amp; namespaceURI, 
                                const std::string&amp; localName, 
                                const std::string&amp; qName);
        virtual void characters(const std::string&amp; ch);

        virtual void fatalError(const SAX::SAXException&amp; exception);

        <xsl:value-of select="$name"/><xsl:text> </xsl:text><xsl:value-of select="$name"/>_;
        SAX::XMLReader&amp; parser_;
        <xsl:if test="not($is-root)">
        SAX::ContentHandler&amp; parent_factory_;  // we are not root
        </xsl:if>
        <xsl:if test="$has-complex-content">
        SAX::ContentHandler* child_factory_;       // we have exciting complex content
        </xsl:if>

        <xsl:for-each select="//xs:element[descendant::xs:element[@ref=$name]]/@name | $this/ancestor::xs:element/@name">
        friend class <xsl:value-of select="."/>_factory; // this type contains me
        </xsl:for-each>
    }; // class <xsl:value-of select="$name"/>_factory
  </xsl:template>

  <xsl:template name="has-complex-content">
    <xsl:param name="this"/>

    <xsl:choose>
      <xsl:when test="boolean($this//xs:element[xs:complexType])">
        true
      </xsl:when>
      <xsl:when test="$this//xs:element[@ref]">
        <xsl:for-each select="$this//xs:element[@ref]/@ref">
          <xsl:variable name="ref" select="."/>
          <xsl:if test="//xs:element[@name=$ref][xs:complexType]">
            true
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
