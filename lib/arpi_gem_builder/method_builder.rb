module ArpiGemBuilder
  class MethodBuilder

    class NoMethodName < StandardError; end;
    class NoHTTPMethod < StandardError; end;

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

    def ruby
      %{
        def #{name}

        end
      }
    end

  end
end