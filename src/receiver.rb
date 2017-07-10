require 'dotenv/load'
require 'telegram/bot'

class Receiver
  attr_reader :message, :bot

  def initialize
    @token = ENV['TOKEN']
    run
  end

  def run
    Telegram::Bot::Client.run(@token) do |bot|
      @bot = bot

      listen { handle_message }
    end
  end

  def listen
    bot.listen do |message|
      @message = message

      yield message
    end
  end

  def handle_message
    RequestHandler.new(self)
  end
end
