require 'helper'

class TestBaseLibFile < Test::Unit::TestCase
  context "Building a base lib file" do
    setup do
      @base_lib = ArpiGemBuilder::BaseLibFile.new("Embedit", "http://embedit.me")
    end

    context "File Generation" do
      should "generate a file" do
        @base_lib.generate(GENERATION_DIR, "test")

        assert File.exists?(GENERATION_DIR + "/test.rb")
      end

      context "Requiring resources" do
        setup do
          resources = ArpiGemBuilder::HTTPResourceFile.extract_and_build(html, "Arrrpi")
          @base_lib.resources = resources
          @base_lib.generate(GENERATION_DIR, "test")
          @file = File.read(GENERATION_DIR + "/test.rb")
        end

        should "require the resource files" do
          assert @file.match(/require "test\/urls"/)
        end
      end
    end
  end

  private

  def html
    @html ||= fixture("embedit_api.html")
  end

  def resource_html
    @resource_html ||= Nokogiri::HTML.parse(fixture("embedit_api.html")).css("div[name=resource]").to_s
  end
end