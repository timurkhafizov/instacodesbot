require "TelegramBot"

class Bot < TelegramBot::Bot
  def initialize
    super("InstacodesBot", ENV["TELEGRAM_BOT_TOKEN"])
  end
end
