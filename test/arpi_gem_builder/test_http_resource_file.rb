require 'helper'

class TestHTTPResourceFile < Test::Unit::TestCase
  context "Class Methods" do
    context "Extracting resources and building objects" do
      should "return 1 HTTPResourceFile object" do
        x = ArpiGemBuilder::HTTPResourceFile.extract_and_build(html, generated_file_path)

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
        assert_equal 1, @resource.methods.size
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
        @resource.generate(generated_file_path)
        assert File.exists?(generated_file_path + "/#{@resource.file_name}.rb")
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

  def generated_file_path
    File.expand_path(File.dirname(__FILE__) + "/../test_data")
  end
end