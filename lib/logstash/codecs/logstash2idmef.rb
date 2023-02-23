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

    class ConstantEventFilter
        def initialize(key, value)
            @key = key
            @value = value
        end

        def apply(event, idmef)
            idmef[@key] = @value
        end
    end

    class VarEventFilter
        def initialize(key, event_key)
            @key = key
            @event_key = event_key
        end

        def apply(event, idmef)
            idmef[@key] = event.get(@event_key)
        end
    end

    @@top_level_filters = [
        ConstantEventFilter.new("Version", "2.0.3"),
        VarEventFilter.new("ID", "[agent][ephemeral_id]"),
        VarEventFilter.new("CreateTime", "[@timestamp]"),
    ]

    def self.from_event(event)
        idmef = Idmef.new
        for f in @@top_level_filters do
            f.apply(event, idmef)
        end
        idmef 
    end

    def to_event()
        {}
    end

end

require('../../../bazar/t1')
event = Event.from_hash(ev1())
p Idmef.from_event(event).to_json
