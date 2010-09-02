require 'helper'

class TestBaseHTTPFile < Test::Unit::TestCase
  context "Building a base HTTP file" do
    setup do
      @base_http = ArpiGemBuilder::BaseHTTPFile.new("http://arrrpi.com", "arrrpi")
    end

    context "Generating file" do
      should "create the file" do
        @base_http.generate(generated_file_path)
        assert File.exists?(generated_file_path + "/base_http.rb")
      end
    end
  end

  private

  def generated_file_path
    File.expand_path(File.dirname(__FILE__) + "/../test_data")
  end
end