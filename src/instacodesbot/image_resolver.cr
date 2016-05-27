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

    def to_image_path : String
      convert_base64_to_png

      tempfile_path("png")
    end

    protected def tempfile_path(file_format : String) : String
      [Tempfile.dirname, File::SEPARATOR, tempfile_name, ".", file_format].join
    end

    protected def tempfile_name : String
      @tempfile_name ||= Crypto::MD5.hex_digest(@code)
    end

    private def convert_base64_to_png
      File.open(tempfile_path("txt"), "w") { |f| f.print("data:image/png;base64,#{base64}") }
      Process.run "convert 'inline:#{tempfile_path("txt")}' #{tempfile_path("png")}", shell: true
      File.delete tempfile_path("txt")
    end
  end
end
