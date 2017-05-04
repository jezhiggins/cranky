# cranky

Released for historic interest.

## An Adventure in Generating XML->C++ Data-Bindings With XSLT

Being a programmer is a bit like being a copper sometimes. You're never off duty.

Sometime early in 2005, my colleague-in-code Allan Kelly posted on an <a href='http://accu.org/'>ACCU</a> mailing list

>    I'd like to be able to take an XML Schema and feed it into a code generator. The generator would produce a set of C++ classes which would allow me to navigate the XML. So, I could pass an XPath/XPointer withing a document to one of these classes, and I could then navigate through the document below, e.g
>
>    XMLRoot address_document(filename, xpath);
>    XMLNode house = address_document->House();
>    int num = house->Number();
>    string road = house->Road();
>
>
>    You get the ideas?
>    So, does it exist?

This kind of thing is called data-binding and I referred him to Google. I mentioned <a href='https://github.com/jezhiggins/bindotron'>BindOTron</a> in passing, and opined

>    I don't see why it wouldn't be possible to generate your C++ classes from schema using a set of XSLT stylesheets

What a crazy fool I was. That idea has been wriggling around in the back of my head in exactly the way crappy songs lodge in your ear even though you only caught two bars of it. So, even though I have a conference presentation to finish, a big pile of Java to port to C#, an article to write, and, if all else fails, some actual live paying work to do, I spent an hour this evening writing enough of a stylesheet to convince myself that it would work. Well I always knew it would work - there's nothing you can't do with a Turing complete language after all - but I've now I know it's going to be pretty easy too.

And within an hour, given this cheesy example -
```
    <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
          elementFormDefault="qualified"
          attributeFormDefault="unqualified">
      <xs:element name="elem">
        <xs:complexType>
          <xs:sequence>
            <xs:element name="first" type="xs:string"/>
            <xs:element name="second" type="xs:string"/>
            <xs:element name="third" type="xs:string"/>
            <xs:element name="number" type="xs:int"/>
          </xs:sequence>
        </xs:complexType>
      </xs:element>
    </xs:schema>
```
you got this cheesy output
```c++
    class elem_impl;

    class elem
    {
      public:
        elem();
        elem(const elem rhs);
        ~elem();

        elem& operator=(const elem& rhs);
        bool operator==(const elem& rhs) const;

        const std::string& get_first() const;
        void set_first(const std::string& new_first);
        const std::string& get_second() const;
        void set_second(const std::string& new_second);
        const std::string& get_third() const;
        void set_third(const std::string& new_third);
        int get_number() const;
        void set_number(int new_number);

        void emit_xml(std::ostream& os) const;

      private:
        void set_impl(elem_impl* impl);
        elem_impl* impl_;
    }; // elem
```

From there, I worked to extend it handle optionals and multiple values.  It is though far from complete.