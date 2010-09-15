require 'helper'
include ArpiGemBuilder

class TestString < Test::Unit::TestCase
  context "#camelize" do
    should "correctly change active_record" do
      assert_equal "ActiveRecord", "active_record".camelize
    end
  end
end