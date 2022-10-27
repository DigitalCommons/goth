require 'goth'

module GOTH

  class Property < GOTH::LabelledDocObject

    def initialize(resource, schema)
      super(resource, schema)
    end

    #helper method
    def get_multiple(property)
      full_uris = []
      @schema.model.query(RDF::Query::Pattern.new( @resource, property ) ) do |statement| #find statement for the given property

        if !statement.object.anonymous? #checks this statement's object
          full_uris << statement.object
         elsif

           #initialise search for multiple domains/ranges
          @schema.model.query( [statement.object, GOTH::Namespaces::OWL.unionOf , nil] ) do | node_statement |
            current_statement = node_statement
            searching = true

            while searching
              @schema.model.query( [current_statement.object, GOTH::Namespaces::RDF.first, nil] ) do | statements |
                full_uris << statements.object

                #now check the next statement
                #object will either be another anonymous node, or nil.
                @schema.model.query( [current_statement.object, GOTH::Namespaces::RDF.rest, nil] ) do | next_statement |
                  if next_statement.object.anonymous?
                    current_statement = next_statement
                  else
                    searching = false
                  end
                end
              end
            end
          end
        end
      end

      classes = []
      full_uris.each do |o|
        if o.resource? #assumes all resources are classes
          uri = o.to_s
          if @schema.classes[uri]
            classes << @schema.classes[uri] #uri suffix only
          else
            classes << uri #full uri
          end
        end
      end
      return classes #either array of classes, or array of uris
    end


    ####### ADDITIONAL ERB METHODS #######
    #not tested
    def sub_property_of()
      parent = @schema.model.first_value(
        RDF::Query::Pattern.new( @resource, GOTH::Namespaces::RDFS.subPropertyOf) )
      if parent #nil if no parent
        uri = parent.to_s
        if @schema.properties[uri]
          return @schema.properties[uri]
        else
          return uri
        end
      end
      return nil
    end

    #not tested
    def sub_properties()
      list = []
      @schema.model.query(RDF::Query::Pattern.new( nil, GOTH::Namespaces::RDFS.subPropertyOf, @resource ) ) do |statement|
        list << GOTH::Property.new( statement.subject, @schema )
      end
      return list
    end

    def range()
      get_multiple(GOTH::Namespaces::RDFS.range)
    end

    def domain()
      get_multiple(GOTH::Namespaces::RDFS.domain)
    end

    def typeOfTerm()
      return "Property"
    end

    def equivalentProperty()
      return get_literal_uri(schema.model, GOTH::Namespaces::OWL.equivalentProperty)
    end

  end

end
