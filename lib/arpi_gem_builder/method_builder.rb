module ArpiGemBuilder
  class MethodBuilder

    class NoMethodName < StandardError; end;

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
        div = @html.css("div[name=operation] label.label")
        div.empty? ? (raise NoMethodName) : div.text
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