require 'goth'

module GOTH

  class Person < GOTH::DocObject
    def initialize(resource, schema)
      super(resource, schema)
    end

	  #for sorting methods
    def <=>(other)
      return name() <=> other.name()
    end

	  ####### ADDITIONAL ERB METHODS #######
    def uri()
      return @resource.to_s
    end

    def name()
      name = get_literal(GOTH::Namespaces::FOAF.name)
      if name == nil
        name = uri()
      end
      return name
    end

  end


  class Ontology < GOTH::DocObject

    def initialize(resource, schema)
      super(resource, schema)
    end

	  ####### ADDITIONAL ERB METHODS #######
    def uri()
      return @resource.to_s
    end

	  def authors()
      authors = []
      @schema.model.query(
        RDF::Query::Pattern.new( @resource, GOTH::Namespaces::FOAF.maker ) ) do |statement|
        authors << Person.new( statement.object, @schema )
      end
      return authors.sort
    end

    def title()
      return get_literal_language(schema.model, GOTH::Namespaces::DCTERMS.title)
    end

    def comment()
      return get_literal(GOTH::Namespaces::RDFS.comment)
    end

    def created()
      return get_literal(GOTH::Namespaces::DCTERMS.created)
    end

    def modified()
      return get_literal(GOTH::Namespaces::DCTERMS.modified)
    end

    def creator()
	    return get_literal_uri(@schema.model, GOTH::Namespaces::DCTERMS.creator)
    end

	  def publisher()
      return get_literal_uri(@schema.model, GOTH::Namespaces::DCTERMS.publisher)
    end

	  def issued()
      return get_literal(GOTH::Namespaces::DCTERMS.issued)
    end

    def description()
      return get_literal_language(schema.model, GOTH::Namespaces::DCTERMS.description)
    end


  end

end
