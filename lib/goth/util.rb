module GOTH

  class DocObject

    attr_reader :resource
    attr_reader :schema

    def initialize(resource, schema)
      @resource = resource
      @schema = schema
    end

	  #helper methods
    def get_literal(property)
      query_pattern = RDF::Query::Pattern.new( @resource, property )
      return @schema.model.first_value(query_pattern)
	  end

	  def get_literal_language(schema_model, property)
    	query_pattern = RDF::Query::Pattern.new( @resource, property )
      results_graph = query_pattern.execute(schema_model)
	    translation = results_graph.first_value() #returns object.to_s
      results_graph.each do |result| #check for translations
	      if result.object.language == @schema.html_language
          translation = result.object.to_s
        end
      end
	    return translation
	  end

	  def get_literal_uri(schema_model, property)
	    literals = []
      schema_model.query(RDF::Query::Pattern.new( @resource, property ) ) do |statement|
        literals << statement.object
      end
	    return literals[0]
	    #this doesnt work, 'do' is needed: return @schema.model.query(RDF::Query::Pattern.new( @resource, property ) ).object
    end

  end


  class LabelledDocObject < GOTH::DocObject

    def initialize(resource, schema)
      super(resource, schema)
    end

	  #for sorting methods
    def <=>(other)
	    return label().downcase <=> other.label().downcase
	  end

    ####### ERB METHODS #######
	  def short_name()
      uri = @resource.to_s
      ontology_uri = @schema.ontology.uri
	    if ontology_uri.end_with?("#") || ontology_uri.end_with?("/")
        ontology_uri = ontology_uri[0..-2]
      end
      name = uri.gsub(/#{ontology_uri}(\/|#)?/, "")
	    return name
    end

	  #not tested, no "seeAlsos" in ESS vocabs
    def see_alsos()
      links = []
      @schema.model.query(
        RDF::Query::Pattern.new( @resource, GOTH::Namespaces::RDFS.seeAlso ) ) do |statement|
        links << statement.object.to_s
      end
      return links
    end

	  def uri
      return @resource.to_s
    end

    def label()
      return get_literal_language(schema.model, GOTH::Namespaces::RDFS.label)
    end

    def comment()
      return get_literal(GOTH::Namespaces::RDFS.comment)
    end

	  def description()
	    return get_literal_language(schema.model, GOTH::Namespaces::DCTERMS.description)
	  end


  end

end
