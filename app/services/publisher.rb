class Publisher

  # publish message to a given queue
  def self.publish(queue_name, message = {})

    # declare a queue
    q  = channel.queue(queue_name, :durable => true, :ack => true)
    
    # publish payload to the required queue
    channel.default_exchange.publish(message.to_json, routing_key: q.name)

    # puts "This is the message: #{message.to_json}"


  end

  def self.channel
    @channel ||= connection.create_channel
  end

  # We are using default settings here
  # The `Bunny.new(...)` is a place to
  # put any specific RabbitMQ settings
  # like host or port
  def self.connection
    @connection ||= Bunny.new.tap do |connec|
      connec.start
    end
  end
end