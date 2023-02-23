require 'json'

class Event < Object
    def initialize
        @event = {}
    end

    def self.from_hash(hash)
        event = Event.new
        hash.each do |key, value|
            event.set(key, value)
        end
        event
    end

    def to_hash()
        @event
    end

    def to_s
        @event.to_s
    end

    def get(key)
        m = key.scan(/\[([[:alnum:]_@]+)\]/)
        value = @event
        m.each do |k| 
            value = value[k[0]] 
        end
        value
    end

    def set(key, value)
        @event[key] = value
        self
    end
end

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

require('../../../bazar/t1')
event = Event.from_hash(ev1())
p Idmef.from_event(event).to_json
