require "erb"
require "arpi_gem_builder/method_builder"

module ArpiGemBuilder
  class BaseFileGenerator

    def initialize(gem_name, base_url, html)
      @html = html
      @gem_name = gem_name
      @base_url = base_url
      @methods = MethodBuilder.extract(html)
    end

    def generate(generate_path)
      erb = ERB.new(File.read(base_template_path))

      File.open(generate_path, "w+") do |file|
        file.write(erb.result(binding))
      end
    end

    private

    def base_template_path
      File.expand_path(File.dirname(__FILE__) + "/templates/base_file.erb")
    end

  end
end