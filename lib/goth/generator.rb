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

    def copy_assets #copy .js and .css assets to working directory
	    #asset_dir = File.join( File.dirname( __FILE__ ), "assets" )
      asset_dir = File.join(File.dirname(__FILE__), "../..", "assets")
	    Dir.new(asset_dir).each() do |file|
        if file != "." and file != ".."
          FileUtils.cp( File.join(asset_dir, file), Dir.pwd )
	      end
      end
    end

    def run()
      copy_assets()
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
