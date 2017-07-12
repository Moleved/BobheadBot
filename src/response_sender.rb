class ResponseSender
  attr_reader :response, :chat_id, :bot

  def initialize(handler, *args)
    @bot = handler.bot
    @chat_id = handler.message.chat.id
    @response = args[0]

    send_response
  end

  def send_response
    response[:type].equal?('document') ? send_document : send_message
  end

  private

  def send_message
    bot.api.send_message(
      chat_id: chat_id,
      text: response.fetch(:content)
    )
  end

  def send_document
    bot.api.send_document(
      chat_id: chat_id,
      document: Faraday::UploadIO.new(response.fetch(:content), 'text/plain')
    )
  end
end
