module ArpiGemBuilder
  class MethodBuilder

    class NoMethodName < StandardError; end;

    class << self
      def extract(noko_html)
        noko_html.css("div[name=operation]").map do |operation|
          new(operation)
        end
      end
    end

    def initialize(noko_html)
      @noko_html = noko_html
    end

    def name
      @name ||= begin
        div = @noko_html.css("div[name=operation] label.label")
        div.empty? ? (raise NoMethodName.new("You need to read the specs!")) : div.text
      end
    end

  end
end