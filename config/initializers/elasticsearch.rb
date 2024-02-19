client = Elasticsearch::Client.new(host: ENV["ELASTICSEARCH_URL"])#, log: true)
# puts client.ping

Elasticsearch::Model.client = client
