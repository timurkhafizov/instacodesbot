require "TelegramBot"

module Instacodesbot
  class Bot < TelegramBot::Bot
    include TelegramBot::CmdHandler

    def initialize
      super("InstacodesBot", ENV["TELEGRAM_BOT_TOKEN"])

      cmd "hello" do |message|
        send_message message.chat.id, "Use /code"
      end

      cmd "code" do |message|
        base64 = Instacodesbot::ImageResolver.resolve("ruby", message.text.to_s)

        logger.debug("Resolving base64 for #{message.text}")
        send_message(message.chat.id, base64.to_s)
      end
    end
  end
end
