require 'goth'

module GOTH
  
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