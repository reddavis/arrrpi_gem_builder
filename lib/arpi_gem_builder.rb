## Idea
#
# ArpiGemBuilder.new(html).generate("../my_folder/")
#
# We will use jeweler to generate the structure of our gems. It also has useful rake tasks to build the gems.
#
## Example
#
# <div name="service">
#   <p>Description of the <span class="label">Embedit</span> service, version <span class="version">0.0.1</span></p>
#
#   <div name="meta-info">
#     <div name="service_name">Embedit</div>
#     <div name="version">0.0.1</div>
#     <div name="created_at">1/4/1990</div>
#     <div name="updated_at">5/5/2010</div>
#     <div name="author">Red Davis</div>
#     <div name="base_url">http://embedit.me</div>
#   </div>
#
#   <div name="operation">
#     <p>
#        The operation <label class="label">get_embed_code</label> is invoked using the method <span class="method">GET</span> at <label class="address">/urls/embed</code>, with the <span class="input">url</span> of the media.
#     </p>
#
#     <p>
#       The operation <span class='authentification'>does not</span> require any authentification.
#     </p>
#
#     <p>
#       It returns the embed details in <span class="output">JSON</span> document.
#     </p>
#   </div>
# </div>
#
# So in theory we will be able to:
#
# require 'embedit'
#
# a = Embedit.get_embed_code(:url => "http://youtube.com")
# a.html
# => "html!"
#
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