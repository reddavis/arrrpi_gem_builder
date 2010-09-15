require 'helper'

class TestTemplatePath < Test::Unit::TestCase
  include ArpiGemBuilder::TemplatePath

  context "#template_path" do
    should "use the current files name" do
      template_file = File.basename(template_path("hello_there"))

      assert_equal "hello_there.erb", template_file
    end
  end
end