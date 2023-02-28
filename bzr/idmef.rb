
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
                self.apply_reverse_mapping(value, idmef, event)
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
