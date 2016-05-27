require "TelegramBot"

module Instacodesbot
  class Bot < TelegramBot::Bot
    include TelegramBot::CmdHandler

    def initialize
      super("InstacodesBot", ENV["TELEGRAM_BOT_TOKEN"])

      cmd "hello" do |message|
        spawn do
          send_message message.chat.id, "Use /code"
        end
      end

      cmd "code" do |message|
        spawn do
          image_path = Instacodesbot::ImageResolver.new("ruby", message.text.to_s).to_image_path

          send_photo(message.chat.id, File.open(image_path.to_s))
        end
      end
    end
  end
end
