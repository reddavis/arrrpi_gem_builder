require 'helper'
require 'httparty'
require 'arpi_gem_builder/method_builder'

class TestMethodBuilder < Test::Unit::TestCase
  include WebMock

  context "One method" do
    setup do
      @method = ArpiGemBuilder::MethodBuilder.new(html_get_method)
    end

    context "Name" do
      should "return get_embed_code" do
        assert_equal "get_embed_code", @method.name
      end

      context "No name" do
        should "raise a NoMethodName" do
          method = ArpiGemBuilder::MethodBuilder.new("")
          assert_raise(ArpiGemBuilder::MethodBuilder::NoMethodName) { method.name }
        end
      end
    end

    context "Ruby method" do
      setup do
        # Dummy class
        class Test
          include ::HTTParty
          base_uri "arrrpi.com"
        end

        # GET request
        Test.send(:instance_eval, ArpiGemBuilder::MethodBuilder.new(html_get_method).ruby)

        # POST request
        Test.send(:instance_eval, ArpiGemBuilder::MethodBuilder.new(html_post_method).ruby)
      end

      should "create an actual method" do
        assert Test.respond_to?(@method.name.to_sym)
      end

      context "GET requests" do
        should "make a request" do
          stub_request(:get, "http://arrrpi.com/urls/embed")
          Test.get_embed_code

          assert_requested :get, "http://arrrpi.com/urls/embed"
        end

        context "With Query parameters" do
          should "make a request" do
            stub_request(:get, "http://arrrpi.com/urls/embed?url=blah")
            Test.get_embed_code(:url => "blah")

            assert_requested :get, "http://arrrpi.com/urls/embed?url=blah"
          end
        end
      end

      context "POST requests" do
        should "make a request" do
          stub_request(:post, "http://arrrpi.com/urls/embed")
          Test.post_embed_code

          assert_requested :post, "http://arrrpi.com/urls/embed"
        end

        context "With Query parameters" do
          should "make a request" do
            stub_request(:post, "http://arrrpi.com/urls/embed?url=blah")
            Test.post_embed_code(:url => "blah")

            assert_requested :post, "http://arrrpi.com/urls/embed?url=blah"
          end
        end
      end
    end

    context "HTTP Method" do
      should "be a GET" do
        assert_equal "GET", @method.http_method
      end

      context "No HTTP Method set" do
        should "raise NoHTTPMethod" do
          method = ArpiGemBuilder::MethodBuilder.new("")
          assert_raise(ArpiGemBuilder::MethodBuilder::NoHTTPMethod) { method.http_method }
        end
      end
    end

    context "URL Address" do
      should "be /urls/embed" do
        assert_equal "/urls/embed", @method.address
      end

      context "No Address" do
        should "raise NoAddress" do
          method = ArpiGemBuilder::MethodBuilder.new("")
          assert_raise(ArpiGemBuilder::MethodBuilder::NoAddress) { method.address }
        end
      end
    end

    context "Inputs" do
      should "return an array" do
        assert_kind_of Array, @method.inputs
      end

      should "include url input" do
        assert @method.inputs.include?("url")
      end
    end
  end

  context "Extracting multiple methods" do
    setup do
      @build_methods = ArpiGemBuilder::MethodBuilder.extract(html_multi_methods)
    end

    context "Count" do
      should "be 3" do
        assert_equal 3, @build_methods.size
      end
    end
  end

  private

  def html_get_method
    %{
      <div name="operation">
        <p>
           The operation <label class="label">get_embed_code</label> is invoked using the method <span class="method">GET</span> at <code class="address">/urls/embed</code>, with the <span class="input">url</span> of the media.
        </p>

        <p>
          The operation <span class='authentification'>does not</span> require any authentification.
        </p>

        <p>
          It returns the embed details in <span class="output">JSON</span> document.
        </p>
      </div>
    }
  end

  def html_post_method
    %{
      <div name="operation">
        <p>
           The operation <label class="label">post_embed_code</label> is invoked using the method <span class="method">POST</span> at <code class="address">/urls/embed</code>, with the <span class="input">url</span> of the media.
        </p>

        <p>
          The operation <span class='authentification'>does not</span> require any authentification.
        </p>

        <p>
          It returns the embed details in <span class="output">JSON</span> document.
        </p>
      </div>
    }
  end

  def html_multi_methods
    %{
      <div name="operation">
        <p>
           The operation <label class="label">one</label> is invoked using the method <span class="method">GET</span> at <code class="address">/urls/embed</code>, with the <span class="input">url</span> of the media.
        </p>

        <p>
          The operation <span class='authentification'>does not</span> require any authentification.
        </p>

        <p>
          It returns the embed details in <span class="output">JSON</span> document.
        </p>
      </div>

      <div name="operation">
        <p>
           The operation <label class="label">two</label> is invoked using the method <span class="method">GET</span> at <code class="address">/urls/embed</code>, with the <span class="input">url</span> of the media.
        </p>

        <p>
          The operation <span class='authentification'>does not</span> require any authentification.
        </p>

        <p>
          It returns the embed details in <span class="output">JSON</span> document.
        </p>
      </div>

      <div name="operation">
        <p>
           The operation <label class="label">three</label> is invoked using the method <span class="method">GET</span> at <code class="address">/urls/embed</code>, with the <span class="input">url</span> of the media.
        </p>

        <p>
          The operation <span class='authentification'>does not</span> require any authentification.
        </p>

        <p>
          It returns the embed details in <span class="output">JSON</span> document.
        </p>
      </div>
    }
  end
end