$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'goth'
require 'test/unit'

class SchemaTest < Test::Unit::TestCase
  
  def test_cannot_create_from_nil_file
      assert_raise RuntimeError do
        GOTH::Schema.create_from_file(nil) 
      end
  end
  
  def test_create_from_file
    file = "examples/example.ttl"
    GOTH::Schema.create_from_file(File.expand_path(file))     
  end
  
  def test_read_classes_from_sample()
    file = "examples/example.ttl"
    schema = GOTH::Schema.create_from_file(File.expand_path(file))     
    classes = schema.classes()
    assert_not_nil classes
    assert_equal(2, classes.length)

    c = classes["http://www.example.org/goth/SomeClass"]
    assert_equal("SomeClass", c.short_name)
    assert_equal("http://www.example.org/goth/SomeClass", c.uri)

  end

  def test_hash_uris()
    file = "examples/example2.ttl"
    schema = GOTH::Schema.create_from_file(File.expand_path(file))     
    classes = schema.classes()
    assert_not_nil classes
    assert_equal(1, classes.length)
    c = classes.values[0]
    assert_equal("SomeClass", c.short_name)
    assert_equal("http://www.example.org/goth#SomeClass", c.uri)
  end

      
  def test_identify_owl_classes()    
    model = RDF::Graph.new()
    model << RDF::Statement.new( RDF::URI.new("http://www.example.com/"), RDF.type, GOTH::Namespaces::OWL.Class)
    schema = GOTH::Schema.new(model)
    assert_equal(1, schema.classes.length)
  end

  def test_identify_rdf_classes()
    model = RDF::Graph.new()
    model << RDF::Statement.new( RDF::URI.new("http://www.example.com/"), RDF.type, GOTH::Namespaces::RDFS.Class)
    schema = GOTH::Schema.new(model)
    assert_equal(1, schema.classes.length)
  end
  
end
