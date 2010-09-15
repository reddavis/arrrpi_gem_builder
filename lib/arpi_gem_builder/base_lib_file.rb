module ArpiGemBuilder
  class BaseLibFile
    include TemplatePath

    attr_accessor :resources

    def initialize(gem_name, base_url)
      @gem_name = gem_name
      @base_url = base_url
      @resources = []
    end

    def generate(generate_path, file_name)
      @file_name = file_name

      # Read the template file
      file_data = File.read(template_path("base_lib_file"))
      erb = Erubis::Eruby.new(file_data)

      File.open("#{generate_path}/#{file_name}.rb", "w+") do |file|
        file.write(erb.result(binding))
      end
    end

  end
end