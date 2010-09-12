module ArpiGemBuilder
  class BaseHTTPFile

    def initialize(base_url, gem_name)
      @base_url = base_url
      @gem_name = gem_name
    end

    def generate(generate_path)
      erb = Erubis::Eruby.new(File.read(base_template_path))

      File.open("#{generate_path}/base_http.rb", "w+") do |file|
        file.write(erb.result(binding))
      end
    end

    private

    def base_template_path
      File.expand_path(File.dirname(__FILE__) + "/templates/base_http_file.erb")
    end

  end
end