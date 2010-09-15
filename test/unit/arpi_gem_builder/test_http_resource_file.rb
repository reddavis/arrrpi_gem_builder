require 'helper'

class TestHTTPResourceFile < Test::Unit::TestCase
  context "Class Methods" do
    context "Extracting resources and building objects" do
      should "return 1 HTTPResourceFile object" do
        x = ArpiGemBuilder::HTTPResourceFile.extract_and_build(html, GENERATION_DIR)

        assert_equal 1, x.size
        assert_kind_of ArpiGemBuilder::HTTPResourceFile, x.first
      end
    end
  end

  context "Building an resource" do
    setup do
      @resource = ArpiGemBuilder::HTTPResourceFile.new("Embedit", resource_html)
    end

    context "Name" do
      should "be urls" do
        assert_equal "urls", @resource.name
      end

      context "No name" do
        should "raise NoName" do
          method = ArpiGemBuilder::HTTPResourceFile.new("Embedit", "")
          assert_raise(ArpiGemBuilder::HTTPResourceFile::NoName) { method.name }
        end
      end
    end

    context "Gem name" do
      should "be Embedit" do
        assert_equal "Embedit", @resource.gem_name
      end
    end

    context "Methods" do
      should "have 1 of them" do
        assert_equal 1, @resource.api_methods.size
      end
    end

    context "Class name" do
      context "Basic name" do
        should "be Urls" do
          assert_equal "Urls", @resource.class_name
        end
      end

      #context "Complex name"
    end

    context "File name" do
      context "Simple name" do
        should "be urls" do
          assert_equal "urls", @resource.file_name
        end
      end

      #context "Complex name"
    end

    context "Generating a file" do
      should "generate a file" do
        @resource.generate(GENERATION_DIR)
        assert File.exists?(GENERATION_DIR + "/#{@resource.file_name}.rb")
      end
    end

    context "Format" do
      context "One format specified" do
        should "be json" do
          assert_equal "json", @resource.api_format
        end
      end

      context "Multiple formats" do
        should "choose the first format" do
          builder = ArpiGemBuilder::HTTPResourceFile.new("Embedit", fixture("multiple_api_format.html"))
          assert_equal "xml", builder.api_format
        end
      end

      context "No Format" do
        should "raise NoFormat" do
          builder = ArpiGemBuilder::HTTPResourceFile.new("Embedit", "")
          assert_raise(ArpiGemBuilder::HTTPResourceFile::NoFormat) { builder.api_format }
        end
      end
    end
  end

  private

  def html
    @html ||= fixture("embedit_api.html")
  end

  def resource_html
    Nokogiri::HTML.parse(fixture("embedit_api.html")).css("div[name=resource]").to_s
  end

  def resource_html_from(fixture_html)
    Nokogiri::HTML.parse(fixture_html).css("div[name=resource]").to_s
  end
end