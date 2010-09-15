require "nokogiri"
require "erubis"
require "FileUtils" unless defined?(FileUtils)

$:.unshift(File.expand_path(File.dirname(__FILE__)))
require "arpi_gem_builder/base_lib_file"
require "arpi_gem_builder/base_http_file"
require "arpi_gem_builder/http_resource_file"

module ArpiGemBuilder
  class Generator

    class NoServiceName < StandardError; end;
    class NoBaseURL     < StandardError; end;

    def initialize(raw_html)
      @raw_html = raw_html
    end

    def generate(save_to)
      @save_to = save_to

      # First lets use jeweler to build the structure
      build_structure
      FileUtils.mkdir_p(resources_file_path)

      # Write the base HTTP file, the resources files inherit off this
      BaseHTTPFile.new(base_url, gem_name).generate(resources_file_path)

      # Write the resource files
      resources = HTTPResourceFile.extract_and_build(@raw_html, gem_name)
      resources.each {|resource| resource.generate(resources_file_path) }

      # Write the base lib file
      base_lib = BaseLibFile.new(gem_name, base_url)
      base_lib.resources = resources
      base_lib.generate(root_file_path, base_file_name)

      #write_tests
    end

    def service_name
      @service_name ||= begin
        x = html.css("div[name=service] div[name=meta-info] div[name=service_name]")

        x.empty? ? (raise NoServiceName.new("No service name, read the specs at...")) : x.text.downcase
      end
    end

    def gem_name
      service_name.split(" ").map {|x| x.capitalize }.join
    end

    def base_url
      @base_url ||= begin
        x = html.css("div[name=service] div[name=meta-info] div[name=base_url]")

        x.empty? ? (raise NoBaseURL) : x.text.downcase
      end
    end

    private

    def root_file_path
      "#{@save_to}/#{service_name}/lib"
    end

    def resources_file_path
      "#{@save_to}/#{service_name}/lib/#{base_file_name}"
    end

    def base_file_name
      service_name.split(" ").join("_").downcase
    end

    def build_structure
      %x{ cd #{@save_to} && jeweler #{base_file_name} }
    end

    def html
      @html ||= Nokogiri::HTML.parse(@raw_html)
    end

  end
end