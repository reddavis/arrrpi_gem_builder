module ArpiGemBuilder
  class TestFile

    def initialize(resource)
      @resource = resource
    end

    def file_name
      @file_name ||= "test_#{@resource.name}"
    end

    def generate(generate_path)
      erb = Erubis::Eruby.new(File.read(template_path))

      File.open("#{generate_path}/#{file_name}.rb", "w+") do |file|
        file.write(erb.result(binding))
      end
    end

    def class_name
      @class_name ||= file_name.camelize
    end

    private

    def template_path
      File.expand_path(File.dirname(__FILE__) + "/templates/test_file.erb")
    end

  end
end