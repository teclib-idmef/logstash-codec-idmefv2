# encoding: utf-8

require "logstash/codecs/base"
require "logstash" # needed for LogStash::Event
require 'json'

class Idmef < Hash

    def self.from_hash(hash)
        idmef = self.new
        hash.each do |key, value|
            idmef[key] = value
        end
        idmef
    end

    @@mapping = {
        "Version" => "2.0.3",
        "ID" => "[agent][ephemeral_id]",
        "CreateTime" => "[@timestamp]",
        "Analyzer" => {
            "Name" => "[agent][name]",
            "Model" => "[agent][type]",
            "Category" => [
                "[input][type]",
            ],
            "Data" => [
                "[input][type]"
            ],
            "Method" => [
                "[@metadata][type]"
            ],
        },
    }

    def self.apply_mapping(mapping, event)
        if mapping.is_a?(Hash)
            h = {}
            mapping.each do |key, value|
                h[key] = self.apply_mapping(value, event)
            end
            return h
        elsif mapping.is_a?(Array)
            a = []
            mapping.each do |value|
                a << self.apply_mapping(value, event)
            end
            return a
        elsif mapping.is_a?(String)
            if mapping.start_with?("[")
                return event.get(mapping)
            else
                return mapping
            end
        end
    end

    def self.from_event(event)
        self.apply_mapping(@@mapping, event)
    end

    def self.apply_reverse_mapping(mapping, idmef, event)
        if mapping.is_a?(Hash)
            mapping.each do |key, value|
                self.apply_reverse_mapping(value, idmef[key], event)
            end
        elsif mapping.is_a?(Array)
            mapping.each do |value|
                self.apply_reverse_mapping(value, idmef[0], event)
            end
        elsif mapping.is_a?(String)
            if mapping.start_with?("[")
                event.set(mapping, idmef)
            end
        end
    end

    def to_event()
        event = Logstash::Event.new
        Idmef.apply_reverse_mapping(@@mapping, self, event)
        event
    end
  
end


class LogStash::Codecs::Idmefv2 < LogStash::Codecs::Base

  # The codec name
  config_name "idmefv2"

  config :defaults, :validate => :boolean, :default => false

  def register
  end # def register

  def decode(data)
    idmef = Idmef.from_hash(JSON.parse(data))
    yield idmef.to_event
  end # def decode

  # Encode a single event, this returns the raw data to be returned as a String
  def encode_sync(event)
    Idmef.from_event(event).to_json
  end # def encode_sync

end # class LogStash::Codecs::Idmefv2
