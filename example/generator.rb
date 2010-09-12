example_dir = File.expand_path(File.dirname(__FILE__))

$:.unshift(example_dir)

require 'rubygems'
require File.expand_path(File.dirname(__FILE__) + "/../lib/arpi_gem_builder")

FileUtils.rm_rf("#{example_dir}/embedit")

export_path = File.expand_path(File.dirname(__FILE__))

html = File.read("#{example_dir}/documentation.html")
ArpiGemBuilder::Generator.new(html).generate(example_dir)