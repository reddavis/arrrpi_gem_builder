require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'
require 'fileutils'
require 'webmock/test_unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'arpi_gem_builder'

GENERATION_DIR = File.expand_path(File.dirname(__FILE__) + "/test_data")

class Test::Unit::TestCase
  def fixture(file_name)
    File.read(File.expand_path(File.dirname(__FILE__) + "/fixtures/#{file_name}"))
  end

  # Empty the test_data folder (apart from the html)
  def teardown
    Dir.glob("#{File.expand_path(File.dirname(__FILE__))}/test_data/**").each do |file_path|
      FileUtils.rm_rf(file_path)
    end
  end
end
