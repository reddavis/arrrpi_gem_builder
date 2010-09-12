require 'helper'

class TestArpiGemBuilder < Test::Unit::TestCase
  include WebMock

  context "Extracting information from the html" do
    setup do
      html = fixture("embedit_api.html")
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

    context "Base URL" do
      should "return http://embedit.me" do
        assert_equal "http://embedit.me", @builder.base_url
      end

      context "No Base URL" do
        should "raise a NoBaseURL error" do
          builder = ArpiGemBuilder::Generator.new("")
          assert_raise(ArpiGemBuilder::Generator::NoBaseURL) { builder.base_url }
        end
      end
    end
  end

  context "Generation" do
    setup do
      html = fixture("embedit_api.html")

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
      end

      context "Basic GET" do
        should "GET /urls/embed" do
          stub_request(:get, "http://embedit.me/urls/embed")
          Embedit::Urls.get_embed_code

          assert_requested :get, "http://embedit.me/urls/embed"
        end
      end
    end
  end
end
