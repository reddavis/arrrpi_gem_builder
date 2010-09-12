module Twitter
  class Timeline < BaseHTTP
    format :json

    class << self
        
      def public_timeline(query_option = {})
        query = query_option.empty? ? {} : {:query => query_option}
        get "/1/statuses/public_timeline", query
      end
      
    end
  end
end