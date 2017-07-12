require 'google/cloud/translate'
require 'dotenv/load'

class Translator
  def self.translate(message)
    translator = Google::Cloud::Translate.new project: project_id
    translator.translate message, to: 'ru'
  end

  private

  def self.project_id
    ENV['PROJECT_ID']
  end
end
