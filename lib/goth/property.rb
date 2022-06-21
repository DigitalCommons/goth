require 'goth'

module GOTH
  
  class Property < GOTH::LabelledDocObject
    
    def initialize(resource, schema)
      super(resource, schema)
    end

	####### ADDITIONAL ERB METHODS #######     
    def uri
      return @resource.to_s
    end

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

	def sub_properties()
      list = []
      @schema.model.query(RDF::Query::Pattern.new( nil, GOTH::Namespaces::RDFS.subPropertyOf, @resource ) ) do |statement|
        list << GOTH::Property.new( statement.subject, @schema )
      end
      return list
    end  
	
    def see_alsos()
       links = []
       @schema.model.query(
         RDF::Query::Pattern.new( @resource, GOTH::Namespaces::RDFS.seeAlso ) ) do |statement|
         links << statement.object.to_s
       end       
       return links
    end
	
    def range()
      ranges = []
      @schema.model.query(RDF::Query::Pattern.new( @resource, GOTH::Namespaces::RDFS.range ) ) do |statement|
        ranges << statement.object
      end  
      classes = []
      ranges.each do |o|
        if o.resource?
          uri = o.to_s        
          if @schema.classes[uri]
            classes << @schema.classes[uri]
          else
            classes << uri
          end
        end
      end
      return classes
    end

    def domain()
      domains = []
      @schema.model.query(RDF::Query::Pattern.new( @resource, GOTH::Namespaces::RDFS.domain ) ) do |statement|
        domains << statement.object
      end  
      classes = []
      domains.each do |o|
        if o.resource?
          uri = o.to_s         
          if @schema.classes[uri]
            classes << @schema.classes[uri]
          else
            classes << uri
          end
        end
        #TODO union
      end
      return classes
    end
    
    def typeOfTerm()
      return "Property"
    end	
	
	
  end

end