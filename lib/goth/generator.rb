module GOTH

  class Generator

    def initialize(schema, template)
      @template = ERB.new(File.read(template))
      @schema = schema
      if schema.introduction
        @introduction = File.read(schema.introduction)
        if schema.introduction.end_with?(".md")
          renderer = Redcarpet::Render::HTML.new({})
          markdown = Redcarpet::Markdown.new(renderer, {})
          @introduction = markdown.render(@introduction)
        end
      end
    end

    def run()
      b = binding #an option for result
      schema = @schema
      introduction = @introduction

      #print whole schema
      #@schema.model.each do |t|
      #puts t
      #end
      #puts @schema.model.count
      #print one domain set - first index is selection, second index always 1
      #puts schema.list_properties()[2][1].domain

      #template is an .erb file, .result(b) returns html text.
      return @template.result(b)
    end


  end

end
