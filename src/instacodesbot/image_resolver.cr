require "crypto/md5"

module Instacodesbot
  class ImageResolver
    HIGHLIGHT_URL = "http://instacod.es/highlight"

    @base64 = String.new

    def initialize(lang : String, code : String)
      @lang = lang
      @code = code
    end

    def base64 : String
      return @base64 if @base64.size > 0

      @base64 = HTTP::Client.post_form(
        HIGHLIGHT_URL, { "theme": "solarized", "language": @lang, "code": @code }
      ).body
    end
  end
end
