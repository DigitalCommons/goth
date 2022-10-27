# coding: utf-8
require 'csv'

module GOTH

  #Utility class providing access to information about the schema, e.g. its description, lists of classes, etc
  class Schema

    attr_reader :model
    attr_reader :introduction
    attr_reader :templatehiddens

    attr_reader :datatype_properties
    attr_reader :object_properties
    attr_reader :classes
    attr_reader :sub_concepts

    attr_reader :extra_models
    attr_reader :extra_conceptss

    attr_reader :html_language
    attr_reader :html_language_s
    attr_reader :html_translations


    # Note: translations, if supplied, should be a hash of phrase IDs
    # to hashes of language phrases keyed by two-letter language ID
    # (lowercase). UTF-8 encoding assumed for non-English characters.
    def initialize(html_language_s, model, extra_models = [], introduction=nil, translations: nil)
      @model = model
      @introduction = introduction
      @templatehiddens = true

      @extra_models = extra_models || []

      @html_language_s = html_language_s
      @html_language = :en #default
      if html_language_s == "en"
        @html_language = :en
      elsif html_language_s == "es"
        @html_language = :es
      elsif html_language_s == "pt"
        @html_language = :pt
      elsif html_language_s == "it"
        @html_language = :it
      elsif html_language_s == "fr"
        @html_language = :fr
      elsif html_language_s == "ko"
        @html_language = :ko
      end

      @html_translations = translations || {}

      # This is the default to when no translation is found for a phrase ID in the target language
      @no_translation = 'NO TRANSLATION AVAILABLE'
      init()
    end

    def Schema.create_from_file(files=[], html_language_s, translations: nil)
      if !files || files.length == 0
        raise "At least one RDF model filename must be provided"
      end

      (model, *extra_models) = files.collect do |file|
          RDF::Graph.load(file)
      end

      translations = {} if translations.nil?
      
      if translations.is_a? String
        translations = self.parse_translations_csv(translations)
      end

      unless translations.is_a? Hash
        raise "Invalid translations parameter: must be a translations hash "
                +"or a translations CSV file path, (not: #{translations})"
      end
      
      Schema.new(html_language_s, model, extra_models || [], translations: translations)
     

      #      dir = File.dirname(file)
      #      if File.exists?(File.join(dir, "introduction.html"))
      #        return Schema.new(html_language_s, model, extra_models, File.join(dir, "introduction.html"))
      #      elsif File.exists?( File.join(dir, "introduction.md"))
      #        return Schema.new(html_language_s, model, extra_models, File.join(dir, "introduction.md"))
      #      else
      #        return Schema.new(html_language_s, model, extra_models)
      #      end
    end


    def init()

      ontology = @model.first_subject( RDF::Query::Pattern.new( nil, RDF.type, GOTH::Namespaces::OWL.Ontology ) )
      if ontology
        @ontology = Ontology.new(ontology, self)
      end

      @classes = Hash.new
      init_classes( GOTH::Namespaces::OWL.Class )
      init_classes( GOTH::Namespaces::RDFS.Class )

      @datatype_properties = init_properties( GOTH::Namespaces::OWL.DatatypeProperty)
      @object_properties = init_properties( GOTH::Namespaces::OWL.ObjectProperty)

      @sub_concepts = init_sub_concepts(GOTH::Namespaces::SKOS.Concept)

      @extra_conceptss = []
      for i in 1..extra_models.length() do
        @extra_conceptss << init_conceptss( i-1, GOTH::Namespaces::SKOS.Concept)
      end

    end

    ### Initialisation methods ###
    def init_classes(type)
      @model.query( RDF::Query::Pattern.new( nil, RDF.type, type ) ) do |statement|
        if !statement.subject.anonymous? #do not collect anonymous nodes
          @classes[ statement.subject.to_s ] = GOTH::Class.new(statement.subject, self)
        end
      end
    end

    def init_properties(type)
      properties = Hash.new
      @model.query( RDF::Query::Pattern.new( nil, RDF.type, type ) ) do |statement|
        properties[ statement.subject.to_s] = GOTH::Property.new(statement.subject, self)
      end
      return properties
    end

    def init_sub_concepts(type)
      sub = Hash.new
      @model.query( RDF::Query::Pattern.new( nil, GOTH::Namespaces::RDFS.subClassOf, type ) ) do |statement|
        sub[ statement.subject.to_s] = GOTH::SubConcept.new(statement.subject, self)
      end
      return sub
    end

    def init_conceptss(index, type)
      concepts = Hash.new
      @extra_models[index].query( RDF::Query::Pattern.new( nil, RDF.type, type ) ) do |statement|
        concepts[ statement.subject.to_s] = GOTH::Concept.new(statement.subject, self, index)
      end
      return concepts
    end


    #helper method
    def properties()
      return @datatype_properties.merge( @object_properties )
    end


    ####### ERB METHODS #######
    def get_html_translation(id)
      return @no_translation unless phrases = @html_translations[id]
      return phrases[@html_language_s] || @no_translation
    end

    def ontology()
      return @ontology
    end

    #Return sorted, nested arrays
    def list_classes()
      return classes().sort { |x,y| x[1] <=> y[1] }
    end

    def list_properties()
      return properties().sort { |x,y| x[1] <=> y[1] }
    end

    def list_datatype_properties()
      return datatype_properties().sort { |x,y| x[1] <=> y[1] }
    end

    def list_object_properties()
      return object_properties().sort { |x,y| x[1] <=> y[1] }
    end

    def list_sub_concepts()
      return sub_concepts.sort { |x,y| x[1] <=> y[1] }
    end

    def list_extra_concepts(index)
      return extra_conceptss[index].sort { |x,y| x[1] <=> y[1] }
    end

    # Converts a standard translations CSV file into a translations
    # look-up hash
    def self.parse_translations_csv(file)
      index = {}
      CSV.foreach(file, headers: true, col_sep: ",", :encoding => 'bom|utf-8') do |row|
        (_, id) = row.delete("Phrase_ID")
        index[id] = row.to_h
      end
      index
    end
    
  end

end
