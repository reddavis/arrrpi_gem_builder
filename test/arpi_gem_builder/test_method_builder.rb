require 'helper'
require 'arpi_gem_builder/method_builder'

class TestMethodBuilder < Test::Unit::TestCase
  context "One method" do
    setup do
      @method = ArpiGemBuilder::MethodBuilder.new(html_one_method)
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
      should "create a working method" do
        class Test; end;
        Test.send(:class_eval, @method.ruby)

        assert Test.new.respond_to?(@method.name.to_sym)
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

  def html_one_method
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