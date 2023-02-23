require 'json'

class Event < Object
    def initialize
        @event = {}
    end

    def self.fromHash(hash)
        event = Event.new
        hash.each do |key, value|
            event.set(key, value)
        end
        event
    end

    def toHash()
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
        def initialize(key, eventKey)
            @key = key
            @eventKey = eventKey
        end

        def apply(event, idmef)
            idmef[@key] = event.get(@eventKey)
        end
    end

    @@filters = [
        ConstantEventFilter.new("Version", "2.0.3"),
        VarEventFilter.new("ID", "[agent][ephemeral_id]"),
        VarEventFilter.new("CreateTime", "[@timestamp]"),
    ]

    def self.fromEvent(event)
        idmef = Idmef.new
        for f in @@filters do
            f.apply(event, idmef)
        end
        idmef 
    end

    def toEvent()
        {}
    end

end

require('../../../bazar/t1')
event = Event.fromHash(ev1())
p Idmef.fromEvent(event).to_json
