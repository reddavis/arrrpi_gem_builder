require "httparty"

$:.unshift(File.expand_path(File.dirname(__FILE__)))

# Base HTTP file
require "twitter/base_http"

# Resources
require "twitter/users"
require "twitter/timeline"
