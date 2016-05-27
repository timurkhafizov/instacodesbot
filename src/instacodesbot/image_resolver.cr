module Instacodesbot
  class ImageResolver
    HIGHLIGHT_URL = "http://instacod.es/highlight"

    def self.resolve(lang : String? = nil, code : String = nil)
      return if lang.nil? || code.nil?

      HTTP::Client.post_form(HIGHLIGHT_URL, { "theme": "solarized", "language": lang, "code": URI.escape(code) }).body.to_s
    end

    def initialize(lang : String, code : String)
      @lang = lang
      @code = code
    end
  end
end
