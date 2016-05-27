require "crypto/md5"

module Instacodesbot
  class ImageResolver
    HIGHLIGHT_URL = "http://instacod.es/highlight"

    @base64 = String.new

    def self.resolve(lang : String = nil, code : String = nil)
      return if lang.nil? || code.nil?

      self.new(lang: lang, code: code).image_file
    end

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

    def image_file : String
      tempfile_name = Crypto::MD5.hex_digest(@code)

      base64_tempfile_path = [Tempfile.dirname, File::SEPARATOR, tempfile_name, ".txt"].join
      File.open(base64_tempfile_path, "w") do |f|
        f.print("data:image/png;base64,#{base64}")
      end

      image_tempfile_path = [Tempfile.dirname, File::SEPARATOR, tempfile_name, ".png"].join

      Process.run("convert 'inline:#{base64_tempfile_path}' #{image_tempfile_path}", shell: true)
      image_tempfile_path
    end
  end
end
