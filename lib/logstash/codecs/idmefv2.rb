# encoding: utf-8
require "logstash/codecs/base"

# This  codec will append a string to the message field
# of an event, either in the decoding or encoding methods
#
# This is only intended to be used as an example.
#
# input {
#   stdin { codec =>  }
# }
#
# or
#
# output {
#   stdout { codec =>  }
# }
#
class LogStash::Codecs::Idmefv2 < LogStash::Codecs::Base

  # The codec name
  config_name "idmefv2"

  config :append, :validate => :string, :default => ', Hello World!'
  config :defaults, :validate => :boolean, :default => false
  config :paths, :validate => :hash, :default => {}

  def register
    @lines = LogStash::Plugin.lookup("codec", "line").new
    @lines.charset = "UTF-8"
  end # def register

  def decode(data)
    @lines.decode(data) do |line|
      replace = { "message" => line.get("message").to_s + @append }
      yield LogStash::Event.new(replace)
    end
  end # def decode

  # Encode a single event, this returns the raw data to be returned as a String
  def encode_sync(event)
    event.get("message").to_s + @append + NL
  end # def encode_sync

end # class LogStash::Codecs::Idmefv2
