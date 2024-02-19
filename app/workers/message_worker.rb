class MessageWorker
  include Sneakers::Worker
  include MessageHelper

  from_queue ENV["MESSAGES_QUEUE"], env: nil
  def work(message_encoded)
    begin
      decoded = JSON.parse(message_encoded)

      puts "Worker in background now execting job on message no.#{decoded["number"]} for chat id #{decoded["chat_id"]}" 
      
      # 1. save the message in DB
      @message = Message.new(decoded)
      @message.save

      # 2. update messages_count in chat
      ChatServices::ChatMessagesCountIncrementer.new(@message.chat).increment

      ack! 

    rescue Exception => e
      # Log the error and reject for reviewal by admin
      puts "Error processing job: #{e.message}"

      return reject!
    end
  end
end