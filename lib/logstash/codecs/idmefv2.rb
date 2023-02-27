# encoding: utf-8

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

require "logstash/codecs/base"
#require "logstash" # needed for LogStash::Event

class Idmef < Hash

  @@filter = {
      "Version" => "2.0.3",
      "ID" => "[agent][ephemeral_id]",
      "CreateTime" => "[@timestamp]",
      "Analyzer" => {
          "Name" => "[agent][name]",
          "Model" => "[agent][type]",
          "Category": [
              "[input][type]",
          ],
          "Data": [
              "[input][type]"
          ],
          "Method": [
              "[@metadata][type]"
          ],
      },
  }

  def self.apply_filter(filter, event)
      if filter.is_a?(Hash)
          h = {}
          filter.each do |key, value|
              h[key] = self.apply_filter(value, event)
          end
          return h
      elsif filter.is_a?(Array)
          a = []
          filter.each do |value|
              a << self.apply_filter(value, event)
          end
          return a
      elsif filter.is_a?(String)
          if filter.start_with?("[")
              return event.get(filter)
          else
              return filter
          end
      end
  end

  def self.from_event(event)
      apply_filter(@@filter, event)
  end

  def to_event()
      {}
  end

end

class LogStash::Codecs::Idmefv2 < LogStash::Codecs::Base

  # The codec name
  config_name "idmefv2"

  config :defaults, :validate => :boolean, :default => false

  def register
  end # def register

  def decode(data)
  end # def decode

  # Encode a single event, this returns the raw data to be returned as a String
  def encode_sync(event)
    Idmef.from_event(event).to_json
  end # def encode_sync

end # class LogStash::Codecs::Idmefv2
