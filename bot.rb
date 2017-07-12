require './src/receiver'
require './src/request_handler'
require './src/response_sender.rb'
require './src/translator.rb'
require './src/document_handler.rb'

class Bot
  def initialize
    Receiver.new
  end
end

Bot.new
