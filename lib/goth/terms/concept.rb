require 'goth'

module GOTH

  class Concept < GOTH::LabelledDocObject

    attr_reader :index
    attr_reader :short_name_value

    def initialize(resource, schema, index)
      @index = index
      super(resource, schema)
      @short_name_value = short_name_constructor()
    end

    #helper methods
    def short_name_constructor()
      uri = @resource.to_s
      base_uri = get_base()
      if base_uri.end_with?("#") || base_uri.end_with?("/")
        base_uri = base_uri[0..-2]
      end
      name = uri.gsub(/#{base_uri}(\/|#)?/, "")
      return name
    end

    def get_base()
      base = Hash.new
      sub = []
      @schema.extra_models[@index].query( RDF::Query::Pattern.new( nil, RDF.type, GOTH::Namespaces::SKOS.ConceptScheme ) ) do |statement|
        sub << statement.subject.to_s
        base[ statement.subject.to_s] = GOTH::ConceptScheme.new(statement.subject, self)
      end
      return base[sub[0]].resource.to_s
    end

    #for sorting methods
    #overrides`
    def <=>(other)
      return short_name_value.downcase <=> other.short_name_value.downcase
    end


    ####### ADDITIONAL ERB METHODS #######
    #overrides
    def short_name()
      return short_name_value
    end

    def typeOfTerm()
      return "Concept"
    end

    def altLabel()
      return get_literal_language(schema.extra_models[@index], GOTH::Namespaces::SKOS.altLabel)
    end

    def inScheme()
      return get_literal_uri(schema.extra_models[@index], GOTH::Namespaces::SKOS.inScheme)
    end

     def prefLabel()
      return get_literal_language(schema.extra_models[@index], GOTH::Namespaces::SKOS.prefLabel)
    end

    def scopeNote()
      return get_literal_uri(schema.extra_models[@index], GOTH::Namespaces::SKOS.scopeNote)
    end

    def broader()
      return get_literal_uri(schema.extra_models[@index], GOTH::Namespaces::SKOS.broader)
    end

  end



  class SubConcept < GOTH::LabelledDocObject

    attr_reader :short_name_value

    def initialize(resource, schema)
      super(resource, schema)
      #@short_name_value = short_name_constructor()
    end

    #for sorting methods
    #overrides`
    def <=>(other)
      return label().downcase <=> other.label().downcase
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

    def issued()
      return get_literal_language(schema.extra_models[@index], GOTH::Namespaces::SKOS.issued)
    end

    def modified()
      return get_literal_language(schema.extra_models[@index], GOTH::Namespaces::SKOS.modified)
    end

    def equivalentClass()
      return get_literal_uri(schema.extra_models[@index], GOTH::Namespaces::OWL.equivalentClass)
    end

    def subClassOf()
      return get_literal_uri(schema.extra_models[@index], GOTH::Namespaces::OWL.subClassOf)
    end

  end



  class ConceptScheme < GOTH::LabelledDocObject

    def initialize(resource, schema)
      super(resource, schema)
    end

    ####### ADDITIONAL ERB METHODS #######
    def uri
      return @resource.to_s
    end

  end


end
