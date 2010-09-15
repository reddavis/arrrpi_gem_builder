module ArpiGemBuilder
  class BaseHTTPFile
    include TemplatePath

    def initialize(base_url, gem_name)
      @base_url = base_url
      @gem_name = gem_name
    end

    def generate(generate_path)
      # Read template data
      file_data = File.read(template_path("base_http_file"))
      erb = Erubis::Eruby.new(file_data)

      File.open("#{generate_path}/base_http.rb", "w+") do |file|
        file.write(erb.result(binding))
      end
    end

  end
end