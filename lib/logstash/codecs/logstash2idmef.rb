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

    class RecEventFilter
        def initialize(key, filters)
            @key = key
            @filters = filters
        end

        def apply(event, idmef)
            h = {}
            Idmef.apply_filters(@filters, event, h)
            idmef[@key] = h
        end
    end

    @@analyzer_filters = [
        VarEventFilter.new("Name", "[agent][name]"),
        VarEventFilter.new("Model", "[agent][type]"),
    ]

    @@top_level_filters = [
        ConstantEventFilter.new("Version", "2.0.3"),
        VarEventFilter.new("ID", "[agent][ephemeral_id]"),
        VarEventFilter.new("CreateTime", "[@timestamp]"),
        RecEventFilter.new("Analyzer", @@analyzer_filters),
    ]

    @@filter = {
        "Version" => "2.0.3",
        "ID" => "[agent][ephemeral_id]",
        "CreateTime" => "[@timestamp]",
        "Analyzer" => {
            "Name" => "[agent][name]",
            "Model" => "[agent][type]",
        },
    }

    def self.apply_filters(filters, event, idmef)
        filters.each do |f|
            f.apply(event, idmef) 
        end
    end

    def self.from_event(event)
        idmef = Idmef.new
        self.apply_filters(@@top_level_filters, event, idmef)
        idmef 
    end

    def to_event()
        {}
    end

end

require('../../../bazar/t1')
event = Event.from_hash(ev1())
p Idmef.from_event(event).to_json
