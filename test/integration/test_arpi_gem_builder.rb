require 'helper'

class TestArpiGemBuilder < Test::Unit::TestCase
  include WebMock

  context "Generation" do
    setup do
      html = fixture("twitter_api.html")

      @builder = ArpiGemBuilder::Generator.new(html)
      @builder.generate(GENERATION_DIR)
    end

    should "create a directory called twitter" do
      assert File.directory?("#{GENERATION_DIR}/twitter")
    end
  end

  context "Using the generated gem" do
    setup do
      html = fixture("twitter_api.html")
      ArpiGemBuilder::Generator.new(html).generate(GENERATION_DIR)
      # Require the generated lib
      require "#{GENERATION_DIR}/twitter/lib/twitter"
      stub_request(:any, /http:\/\/twitter.com/)
    end

    context "Users" do
      context "GET show" do
        should "request the correct url" do
          Twitter::Users.show(:screen_name => "reddavis")

          assert_requested :get, "http://twitter.com/users/show?screen_name=reddavis"
        end
      end
    end
  end
end
