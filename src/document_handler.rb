require 'telegramAPI'

class DocumentHandler
  attr_reader :document, :api

  def initialize(request_handler)
    @token = ENV['TOKEN']
    @document = request_handler.message.document

    @api = TelegramAPI.new(@token)
  end

  def translate_document
    File.new('translated.txt', 'w').puts translate_content
  end

  private

  def get_file_content
    puts api.getFile(document.file_id).fetch('file_path')
    open("https://api.telegram.org/file/bot#{@token}/#{api.getFile(document.file_id)['file_path']}") do |f|
      @text = f.readlines
    end
  end

  def translate_content
    get_file_content

    Translator.translate @text
  end
end
