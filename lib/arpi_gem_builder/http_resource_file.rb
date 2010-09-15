require "arpi_gem_builder/method_builder"

module ArpiGemBuilder
  class HTTPResourceFile

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
      erb = Erubis::Eruby.new(File.read(base_template_path))

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

    def class_name
      @class_name ||= begin
        # cool_images => CoolImages
        name.split(/[_|\s+]/).map {|x| x.capitalize }.join
      end
    end

    private

    def base_template_path
      File.expand_path(File.dirname(__FILE__) + "/templates/http_resource_file.erb")
    end

  end
end