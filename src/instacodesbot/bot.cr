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
    end

    def handle(inline_query : TelegramBot::InlineQuery)
      spawn do
        results = Array(TelegramBot::InlineQueryResult).new
        results << TelegramBot::InlineQueryResultPhoto.new(
          "1", "http://loremflickr.com/640/480?random=1", "http://loremflickr.com/320/240?random=1")
        answer_inline_query(inline_query.id, results)
      end
    end
  end
end
