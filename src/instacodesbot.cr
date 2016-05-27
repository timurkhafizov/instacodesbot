ENV["CRYSTAL_ENV"] ||= "development"

Ambience.application(File.expand_path("#{__DIR__}/../config/env.yml"), ENV["CRYSTAL_ENV"])
Ambience.load

require "./instacodesbot/*"
