require 'helper'

class TestBaseHTTPFile < Test::Unit::TestCase
  context "Building a base Test file" do
    setup do
      @resource = ArpiGemBuilder::HTTPResourceFile.new("Embedit", resource_html)
      @test_file = ArpiGemBuilder::TestFile.new(@resource)
    end

    context "Filename" do
      should "be test_urls" do
        assert_equal "test_urls", @test_file.file_name
      end
    end

    context "Classname" do
      should "be TestUrls" do
        assert_equal "TestUrls", @test_file.class_name
      end
    end

    context "Generating file" do
      should "create the file" do
        @test_file.generate(GENERATION_DIR)
        assert File.exists?(GENERATION_DIR + "/test_urls.rb")
      end
    end
  end

  private

  # Resource = Urls
  # Operation
  # => get_embed_code
  #    => GET
  def resource_html
    Nokogiri::HTML.parse(fixture("embedit_api.html")).css("div[name=resource]").to_s
  end
end

#
#<div name="resource">
#  <label class="label">Urls</label>
#
#  <div name="operation">
#    <p>
#       The operation <label class="label">get_embed_code</label> is invoked using the method <span class="method">GET</span> at <code class="address">/urls/embed</code>, with the <span class="input">url</span> of the media.
#    </p>
#
#    <p>
#      The operation <span class='authentication'>does not</span> require any authentication.
#    </p>
#
#    <p>
#      It returns the embed details in <span class="output">JSON</span> document.
#    </p>
#  </div>
#</div>