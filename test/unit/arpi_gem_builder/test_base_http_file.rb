require 'helper'

class TestBaseHTTPFile < Test::Unit::TestCase
  context "Building a base HTTP file" do
    setup do
      @base_http = ArpiGemBuilder::BaseHTTPFile.new("http://arrrpi.com", "arrrpi")
    end

    context "Generating file" do
      should "create the file" do
        @base_http.generate(GENERATION_DIR)
        assert File.exists?(GENERATION_DIR + "/base_http.rb")
      end
    end
  end
end