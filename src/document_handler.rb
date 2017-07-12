require 'telegramAPI'
require 'open-uri'

class DocumentHandler
  attr_reader :document, :api, :url

  def initialize(request_handler)
    @token = ENV['TOKEN']
    @document = request_handler.message.document

    @api = TelegramAPI.new(@token)
    @url = "https://api.telegram.org/file/bot#{@token}/#{api.getFile(document.file_id)['file_path']}"
  end

  def translate_document
    File.open('translated.txt', 'w') { |file| file.write(translate_content) }
  end

  private

  def get_file_content
    open(url) do |f|
      @text = f.readlines
    end
  end

  def translate_content
    get_file_content

    Translator.translate @text
  end
end
