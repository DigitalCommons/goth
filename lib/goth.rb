require 'rubygems'
require 'erb'
require 'fileutils'
require 'linkeddata'
require 'redcarpet'

require 'goth/generator'
require 'goth/schema'
require 'goth/util'

require 'goth/terms/ontology'
require 'goth/terms/class'
require 'goth/terms/property'
require 'goth/terms/concept'


module GOTH

  class Namespaces

    OWL = RDF::Vocabulary.new("http://www.w3.org/2002/07/owl#")
    #RDFS = RDF::RDFS
    RDFS =  RDF::Vocabulary.new("http://www.w3.org/2000/01/rdf-schema#")
    VS = RDF::Vocabulary.new("http://www.w3.org/2003/06/sw-vocab-status/ns#")
    DCTERMS = RDF::Vocabulary.new("http://purl.org/dc/terms/")
    FOAF = RDF::Vocabulary.new("http://xmlns.com/foaf/0.1/")
    SKOS = RDF::Vocabulary.new("http://www.w3.org/2004/02/skos/core#")
    RDF = RDF::Vocabulary.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#")

  end


  private

  # Location of asset files
  def self.assetfile(filename)
    File.join(File.dirname(__FILE__), "goth/assets", filename)
  end

  public
  
  # Locations of default assets
  DefaultTranslationsFile = self.assetfile("ERB_TRANSLATIONS_FULL.csv")
  DefaultTemplateFile = self.assetfile("esstemplate.erb")
  
end
