require 'time'

def ev1()
    {
        "input" => {
            "type" => "log"
        },
        "agent" => {
            "name" => "7d6cbe7c404e",
            "id" => "e524972f-8415-48f3-8f5e-25d6689a65b9",
            "ephemeral_id" => "ac7fca10-dcca-4072-8a42-e8d46d5d3855",
            "type" => "filebeat",
            "version" => "8.6.1"
        },
        "@timestamp" => Time.parse('2023-02-04T11:04:54.480Z'),
        "ecs" => {
            "version" => "8.0.0"
        },
        "log" => {
            "file" => {
                "path" => "/logs/nginx/access.log"
            },
            "offset" => 0
        },
        "@metadata" => {
            "input" => {
                "beats" => {
                    "host" => {
                        "ip" => "192.168.0.4"
                    }
                }
            },
            "type" => "_doc",
            "version" => "8.6.1",
            "beat" => "filebeat"
        },
        "host" => {
            "name" => "7d6cbe7c404e"
        },
        "@version" => "1",
        "message" => "192.168.0.1 - - [04/Feb/2023:11:04:44 +0000] \"GET /zob HTTP/1.1\" 404 154 \"-\" \"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0\" \"-\"",
        "event" => {
            "original" => "192.168.0.1 - - [04/Feb/2023:11:04:44 +0000] \"GET /zob HTTP/1.1\" 404 154 \"-\" \"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0\" \"-\""
        },
        "tags" => [
            "beats_input_codec_plain_applied"
        ]
    }
end

def idmef1()
    {
        "Version" => "2.0.3",
        "ID" => "219afef3-7dbc-4570-9381-e1fcc9019c0b",
        "CreateTime" => "2021-11-26T16:30:12.245313",
        "Analyzer" => {
            "IP" => "127.0.0.1",
            "Name" => "foobar",
            "Model" => "generic",
            "Category" => [
                "LOG",
            ],
            "Data" => [
                "Log",
            ],
            "Method" => [
                "Monitor",
            ],
        },
    }
end

