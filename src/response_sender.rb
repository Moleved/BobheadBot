class ResponseSender
  attr_reader :response, :message, :bot

  def initialize(handler, *args)
    @bot = handler.bot
    @message = handler.message
    @response = args[0]

    send_response
  end

  def send_response
    response.fetch(:type).equal?('document') ? send_document : send_message
  end

  private

  def send_message
    bot.api.send_message(
      chat_id: message.chat.id,
      text: response.fetch(:content)
    )
  end

  def send_document
    bot.api.send_document(
      chat_id: message.chat.id,
      document: Faraday::UploadIO.new(response.fetch(:content), 'text/plain')
    )
  end
end
