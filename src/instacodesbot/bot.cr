require "TelegramBot"
require "crypto/md5"
require "json"

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

        # Skip very short queries
        if inline_query.query.size > 10
          image_base64 = ImageResolver.new(lang: "ruby", code: inline_query.query).base64
          imgur_response = HTTP::Client.post_form(
            "https://api.imgur.com/3/image",
            { "image" => image_base64, "album" => ENV["IMGUR_ALBUM_DELETEHASH"]},
            HTTP::Headers{ "Authorization" => "Client-ID #{ENV["IMGUR_CLIENT_ID"]}" }
          ).body

          image_url = JSON.parse(imgur_response.to_s)["data"]["link"]

          results << TelegramBot::InlineQueryResultPhoto.new(
            Crypto::MD5.hex_digest(image_base64), image_url.to_s, image_url.to_s)
        end

        answer_inline_query(inline_query.id, results)
      end
    end
  end
end
