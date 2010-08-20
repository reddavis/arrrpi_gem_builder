require 'helper'

class TestArpiGemBuilder < Test::Unit::TestCase
  include WebMock

  context "Extracting information from the html" do
    setup do
      html = File.read(File.expand_path(File.dirname(__FILE__) + "/html_sample/embedit_api.html"))
      @builder = ArpiGemBuilder::Generator.new(html)
    end

    context "service_name" do
      should "return embedit" do
        assert_equal "embedit", @builder.service_name
      end

      context "No service_name" do
        should "raise a NoServiceName error" do
          builder = ArpiGemBuilder::Generator.new("")
          assert_raise(ArpiGemBuilder::Generator::NoServiceName) { builder.service_name }
        end
      end
    end

    context "Gem name" do
      context "Simple name" do
        should "return Embedit" do
          assert_equal "Embedit", @builder.gem_name
        end
      end

      context "Complex name" do
        should "return EmbeditGem" do
          builder = ArpiGemBuilder::Generator.new(%{<div name="service"><div name="meta-info"><div name="service_name">Embedit Gem</div></div></div>})
          assert_equal "EmbeditGem", builder.gem_name
        end
      end
    end
  end

  context "Generation" do
    setup do
      html = File.read(File.expand_path(File.dirname(__FILE__) + "/html_sample/embedit_api.html"))

      @dir = File.expand_path(File.dirname(__FILE__) + "/test_data")
      @builder = ArpiGemBuilder::Generator.new(html)
      @builder.generate(@dir)
    end

    should "create a directory called embedit" do
      assert File.directory?("#{@dir}/embedit")
    end

    context "Using the generated gem" do
      setup do
        # Require the generated lib
        require "#{@dir}/embedit/lib/embedit"
        stub_request(:any, /embedit.me/)
      end

      should "call http://embedit.me/get_embed_code" do
        Embedit.get_embed_code

        assert_requested(:get, /http:\/\/embedit.me\/get_embed_code/, :times => 1)
      end
    end
  end
end
