module GOTH

  class Class < GOTH::LabelledDocObject
    include Comparable

    attr_reader :resource

    def initialize(resource, schema)
      super(resource, schema)
    end


	####### ADDITIONAL ERB METHODS #######

	#not tested
    def sub_class_of()
      parent = @schema.model.first_value(
        RDF::Query::Pattern.new( @resource, GOTH::Namespaces::RDFS.subClassOf ) )
      if parent #nil if no parent
        uri = parent.to_s
        if @schema.classes[uri]
          return @schema.classes[uri]
        else
          return uri
        end
      end
      return nil
    end

	#not tested
    def sub_classes()
      list = []

      @schema.model.query(
        RDF::Query::Pattern.new( nil, GOTH::Namespaces::RDFS.subClassOf, @resource) ) do |statement|
          list << GOTH::Class.new(statement.subject, @schema)
      end
      return list
    end

    def to_s
      return short_name
    end

    def typeOfTerm()
      return "Class"
    end


  end

end