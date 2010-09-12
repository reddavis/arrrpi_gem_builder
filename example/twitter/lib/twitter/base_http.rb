module Twitter
  class BaseHTTP
    include HTTParty
    base_uri "http://twitter.com"
  end
end