require 'json'
require 'logstashstub'
require 'idmef'
require 'example1'

event = Logstash::Event.from_hash(ev1())
p event
'======================'
p Idmef.from_event(event).to_json
'======================'
idmef1 = Idmef.from_hash(idmef1())
p idmef1
'======================'
p idmef1.to_event()
