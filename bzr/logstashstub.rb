module Logstash
    class Event < Object
        def initialize
            @event = {}
        end

        def self.from_hash_rec(hash, event, parent_key)
            if hash.is_a?(Hash)
                hash.each do |key, value|
                    self.from_hash_rec(value, event, "#{parent_key}[#{key}]")
                end 
            else
                event.set("#{parent_key}", hash)
            end
        end

        def self.from_hash(hash)
            event = Event.new
            self.from_hash_rec(hash, event, "")
            event
        end

        def to_hash()
            @event
        end

        def to_s
            @event.to_s
        end

        def get(key)
            @event[key]
        end

        def set(key, value)
            @event[key] = value
            self
        end
    end
end
