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
	
	#for sorting methods
	#overrides`
    def <=>(other)
	    return short_name_value.downcase <=> other.short_name_value.downcase
	end 

    ####### ADDITIONAL ERB METHODS #######  	
    def uri
      return @resource.to_s
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

end