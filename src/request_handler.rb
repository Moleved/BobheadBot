require 'yaml'

class RequestHandler
  attr_reader :message, :bot, :receiver

  def initialize(receiver)
    @receiver = receiver
    @message = receiver.message
    @bot = receiver.bot

    @answers = YAML.load_file(
      File.join(File.dirname(__FILE__), 'data', 'message.yml')
    )

    handle_message
  end

  def handle_message
    case message.text
    when 'What time is it?'
      send_response Time.now.strftime('%T')
    when '/start'
      send_response @answers[:start]
      send_response @answers[:commands]
    when '/stop'
      send_response @answers[:stop]
    when '/translate'
      send_response @answers[:translate]

      receiver.listen do |message|
        break if message.text == '/break'

        send_response Translator.translate message
      end
    when '/translate_document'
      send_response @answers[:translate]

      receiver.listen do |message|
        send_response @answers['no_command'] if message.document.nil?
        break if message.text == '/break'

        @message = message
        send_response handle_document, 'document'
      end
    when '/commands'
      send_response @answers[:commands]
    else
      send_response @answers[:no_command]
    end
  end

  def handle_document
    DocumentHandler.new(self).translate_document
  end

  private

  def send_response(response, type = 'message')
    ResponseSender.new(self, { type: type, content: response })
  end

  def document?
    !message.document.nil?
  end

  def text?
    !message.text.nil?
  end
end
