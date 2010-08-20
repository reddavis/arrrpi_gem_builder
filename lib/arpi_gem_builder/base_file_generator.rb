module ArpiGemBuilder
  class BaseFileGenerator

    def initialize(gem_name, html)
      @html = html
      @gem_name = gem_name
      @methods = MethodBuilder.extract(html)
    end

    def generate
      erb = ERB.new(File.read(base_template_path))
    end

    private

    def base_template_path
      File.expand_path(File.dirname(__FILE__) + "/templates/base_file.erb")
    end

  end
end