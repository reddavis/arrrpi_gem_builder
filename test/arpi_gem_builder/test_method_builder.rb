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
    end

    context "No name" do
      should "raise a NoMethodName" do
        method = ArpiGemBuilder::MethodBuilder.new("")
        assert_raise(ArpiGemBuilder::MethodBuilder::NoMethodName) { method.name }
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
           The operation <label class="label">get_embed_code</label> is invoked using the method <span class="method">GET</span> at <label class="address">/urls/embed</code>, with the <span class="input">url</span> of the media.
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
           The operation <label class="label">one</label> is invoked using the method <span class="method">GET</span> at <label class="address">/urls/embed</code>, with the <span class="input">url</span> of the media.
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
           The operation <label class="label">two</label> is invoked using the method <span class="method">GET</span> at <label class="address">/urls/embed</code>, with the <span class="input">url</span> of the media.
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
           The operation <label class="label">three</label> is invoked using the method <span class="method">GET</span> at <label class="address">/urls/embed</code>, with the <span class="input">url</span> of the media.
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