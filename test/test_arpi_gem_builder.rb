require 'helper'

class TestArpiGemBuilder < Test::Unit::TestCase
  context "Extracting information from the html" do
    setup do
      html = File.read(File.expand_path(File.dirname(__FILE__) + "/test_data/embedit_api.html"))
      @builder = ArpiGemBuilder.new(html)
    end

    context "service_name" do
      should "return embedit" do
        assert_equal "embedit", @builder.service_name
      end

      context "No service_name" do
        should "raise a NoServiceName error" do
          builder = ArpiGemBuilder.new("")
          assert_raise(ArpiGemBuilder::NoServiceName) { builder.service_name }
        end
      end
    end
  end

  context "Generation" do
    setup do
      html = File.read(File.expand_path(File.dirname(__FILE__) + "/test_data/embedit_api.html"))

      @dir = File.expand_path(File.dirname(__FILE__) + "/test_data")
      @builder = ArpiGemBuilder.new(html)
    end

    should "create a directory called embedit" do
      @builder.generate(@dir)

      assert File.directory?("#{@dir}/embedit")
    end
  end
end
