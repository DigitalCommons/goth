VER = "0.1.0"

RDOC_OPTS = ['--quiet', '--title', 'goth Reference', '--main', 'README']

PKG_FILES = %w( README Rakefile CHANGES ) +
            Dir.glob("{bin,doc,tests,examples,lib}/**/*")

Gem::Specification.new do |s|
  s.name = "goth"
  s.version = VER
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = ">= 1.9"
  s.extra_rdoc_files = ["README", "CHANGES"]
  s.rdoc_options = RDOC_OPTS
  s.summary = "goth OWL/RDF doc generator"
  s.description = "Generate simple HTML documentation for subset of RDFS/OWL"
  s.author = "Thomas Davison"
  s.email = 'thomas.davison@code-operative.co.uk'
  s.homepage = 'http://github.com/DigitalCommons/goth'
  s.files = PKG_FILES
  s.require_path = "lib"
  s.bindir = "bin"
  s.executables = ["goth"]
  #    s.test_file = "tests/ts_goth.rb"
  s.add_dependency("mocha", ">= 0.9.5")
  s.add_dependency("linkeddata", ">=1.0")
  s.add_dependency("redcarpet", ">=2.2.2")
end
