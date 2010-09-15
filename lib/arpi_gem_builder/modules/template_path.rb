module ArpiGemBuilder
  module TemplatePath
    def template_path(file_name)
      File.expand_path(File.dirname(__FILE__) + "/../templates/#{file_name}.erb")
    end
  end
end