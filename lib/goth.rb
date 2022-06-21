require 'rubygems'
require 'erb'
require 'fileutils'
require 'linkeddata'
require 'redcarpet'

require 'goth/util'
require 'goth/schema'
require 'goth/class'
require 'goth/property'
require 'goth/ontology'
require 'goth/generator'
require 'goth/concept'
require 'goth/conceptscheme'

module GOTH
      
  class Namespaces

    OWL = RDF::Vocabulary.new("http://www.w3.org/2002/07/owl#")    
    RDFS = RDF::RDFS    
    VS = RDF::Vocabulary.new("http://www.w3.org/2003/06/sw-vocab-status/ns#")
    DCTERMS = RDF::Vocabulary.new("http://purl.org/dc/terms/")
    FOAF = RDF::Vocabulary.new("http://xmlns.com/foaf/0.1/")
	SKOS = RDF::Vocabulary.new("http://www.w3.org/2004/02/skos/core#")
        
  end

end