require "TelegramBot"

module Instacodesbot
  class Bot < TelegramBot::Bot
    include TelegramBot::CmdHandler

    def initialize
      super("InstacodesBot", ENV["TELEGRAM_BOT_TOKEN"])

      cmd "hello" do |message|
        send_message message.chat.id, "Use /code !"
      end
    end
  end
end
