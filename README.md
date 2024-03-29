# GOTH

GOTH (Generate OWL to HTML) is a simple command-line tool for generating human-readable HTML documentation of the ESS RDFS/OWL vocab/schema.

- Author: Thomas Davison, on behalf of Digital Commons.
- Original seed for this code downloaded 28/03/2022 from: https://github.com/ldodds/dowl

## INSTALLATION INSTRUCTIONS

Briefly, include this gem in your Gemfile, via its Git URL. For example:

    source "https://rubygems.org"
    gem "goth", :github => "DigitalCommons/goth", :branch => "master"


Then either install normally using the `gem` command, or use `bundler`
to install. An example of the latter:

    bundle install

The `goth` command should then be available when run via `bundle exec`

    bundle exec goth

## USAGE

The `goth` script requires three parameters.

1. locations of the .ttl vocab/schema files to parse, it must contain an ontology.
2. language tag indicating which language to extract from the .tll, e.g. en or fr.
3. location of the .erb file that contains the HTML template for output.

The script sends its output to STDOUT so just pipe it into a file.

e.g:

    bash$ bin/goth [array of input files] -l en -t esstemplate.erb > essglobal-vocab_en.html

The `generate_all.sh` script demonstrates a workable usecase.

`-l` and `-t` are optional arguments. If these options are not specified the defaults "en" and "esstemplate.erb" will be used.

The script will automatically include the contents of introduction.html, if found in the same directory as the schema, into the documentation. This file should contain a HTML fragment.

The script relies on a .csv file which contains translations for phrases within the HTML (in addition to translations already contained within the .ttl itself). Its directory is currently hardcoded. If generating this .csv from a .xlxs, ensure that "CSV UTF-8 (Comma delimited)" is selected.

## CODE OVERVIEW:

- bin/goth

This is the executable, it creates a "schema" for a "generator", and then runs the generator with the chosen "template".

- html_to_owl/lib/goth/generator.rb
- html_to_owl/lib/goth/schema.rb
- html_to_owl/esstemplate.erb

Running a generator returns the results of esstemplate.erb, the html.

Schemas include models (RDF::Graph) and collections of "RDF statements" taken from these models. The collections are statements with common term type: ontology, classes, properties, ves_classes, extra_concepts.

"util" describes DocObjects and LabelledDocObjects. Ontologies are extended DocObjects. Classes, properties and extra_concepts are extended LabelledDocObjects.

- lib/goth/util.rb
- lib/goth/ontology.rb
- lib/goth/class.rb
- lib/goth/property.rb
- lib/goth/concept.rb

These files contain all the methods required to extract data from the RDF statements within the .erb template.

Finally, `goth` includes helper RDF::Vocabularies, as global Namespaces, necessary for extracting this data.

## TESTS

See [tests/README.md](tests/README.md).


