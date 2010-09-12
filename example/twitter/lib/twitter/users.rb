module Twitter
  class Users < BaseHTTP
    format :json

    class << self
        
      def show(query_option = {})
        query = query_option.empty? ? {} : {:query => query_option}
        get "/users/show", query
      end

    end
  end
end