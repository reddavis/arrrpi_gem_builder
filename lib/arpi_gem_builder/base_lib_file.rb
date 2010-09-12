module ArpiGemBuilder
  class BaseLibFile

    attr_accessor :resources

    def initialize(gem_name, base_url)
      @gem_name = gem_name
      @base_url = base_url
      @resources = []
    end

    def generate(generate_path, file_name)
      @file_name = file_name
      erb = Erubis::Eruby.new(File.read(base_template_path))

      File.open("#{generate_path}/#{file_name}.rb", "w+") do |file|
        file.write(erb.result(binding))
      end
    end

    private

    def base_template_path
      File.expand_path(File.dirname(__FILE__) + "/templates/base_lib_file.erb")
    end

  end
end