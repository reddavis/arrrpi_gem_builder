module ArpiGemBuilder
  class TestFile
    include TemplatePath

    def initialize(resource)
      @resource = resource
    end

    def file_name
      @file_name ||= "test_#{@resource.name}"
    end

    def generate(generate_path)
      file_data = File.read(template_path("test_file"))
      erb = Erubis::Eruby.new(file_data)

      File.open("#{generate_path}/#{file_name}.rb", "w+") do |file|
        file.write(erb.result(binding))
      end
    end

    def class_name
      @class_name ||= file_name.camelize
    end

  end
end