require 'rubygems'
require 'erb'
require 'fileutils'
require 'linkeddata'
require 'redcarpet'

require 'goth/util'
require 'goth/schema'
require 'goth/terms/class'
require 'goth/terms/property'
require 'goth/terms/ontology'
require 'goth/generator'

module GOTH
      
  class Namespaces

    OWL = RDF::Vocabulary.new("http://www.w3.org/2002/07/owl#")    
    RDFS = RDF::RDFS    
    VS = RDF::Vocabulary.new("http://www.w3.org/2003/06/sw-vocab-status/ns#")    
    DCTERMS = RDF::Vocabulary.new("http://purl.org/dc/terms/")
    FOAF = RDF::Vocabulary.new("http://xmlns.com/foaf/0.1/")
        
  end

end
