require "arpi_gem_builder/method_builder"

module ArpiGemBuilder
  class HTTPResourceFile
    include TemplatePath

    class << self
      def extract_and_build(html, gem_name)
        Nokogiri::HTML.parse(html).css("div[name=resource]").map do |element|
          new(gem_name, element.to_s)
        end
      end
    end

    # Errors
    class NoName < StandardError; end;
    class NoFormat < StandardError; end;

    attr_reader :gem_name, :api_methods

    def initialize(gem_name, html)
      @gem_name = gem_name
      @html = html
      @api_methods = MethodBuilder.extract(html)
    end

    def generate(generate_path)
      file_data = File.read(template_path("http_resource_file"))
      erb = Erubis::Eruby.new(file_data)

      File.open("#{generate_path}/#{file_name}.rb", "w+") do |file|
        file.write(erb.result(binding))
      end
    end

    def name
      @name ||= begin
        x = Nokogiri::HTML.parse(@html).css("div[name=resource] label.label").first
        x.nil? ? (raise NoName) : x.text.downcase
      end
    end

    # If there are multiple formats, we only take note of the first one.
    # Reason being that we are only building a scaffold
    def api_format
      @api_format ||= begin
        x = Nokogiri::HTML.parse(@html).css("div[name=resource] span.output").first
        x.nil? ? (raise NoFormat) : x.text.downcase.split(",").map {|x| x.strip }.first
      end
    end

    def file_name
      @file_name ||= begin
        name.gsub(/\s+/, "_")
      end
    end

    # cool_images => CoolImages
    def class_name
      @class_name ||= name.camelize
    end

  end
end