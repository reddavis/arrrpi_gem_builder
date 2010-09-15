module ArpiGemBuilder
  class MethodBuilder

    # Errors
    class NoMethodName < StandardError; end;
    class NoHTTPMethod < StandardError; end;
    class NoAddress    < StandardError; end;

    class << self
      def extract(html)
        Nokogiri::HTML.parse(html).css("div[name=operation]").map do |operation|
          new(operation.to_s)
        end
      end
    end

    def initialize(html)
      @html = Nokogiri::HTML.parse(html)
    end

    def name
      @name ||= begin
        x = @html.css("div[name=operation] label.label")
        x.empty? ? (raise NoMethodName) : x.text
      end
    end

    def http_method
      @http_method ||= begin
        x = @html.css("div[name=operation] span.method")
        x.empty? ? (raise NoHTTPMethod) : x.text.upcase
      end
    end

    def address
      @address ||= begin
        x = @html.css("div[name=operation] code.address")
        x.empty? ? (raise NoAddress) : x.text
      end
    end

    def inputs
      @inputs ||= begin
        @html.css("div[name=operation] span.input").map {|input| input.text }
      end
    end

    def ruby
      %{
      def #{name}(query_option = {})
        query = query_option.empty? ? {} : {:query => query_option}
        #{http_method.downcase} "#{address}", query
      end}
    end

  end
end