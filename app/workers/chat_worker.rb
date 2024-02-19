class ChatWorker
  include Sneakers::Worker
  include ChatHelper

  from_queue ENV["CHATS_QUEUE"], env: nil
  def work(chat_encoded)
    begin
      decoded = JSON.parse(chat_encoded)
      
      puts "Worker in background now execting job on chat no.#{decoded["number"]} for app id #{decoded["application_id"]}" 

      # 1. save the chat in DB
      @chat = Chat.new(decoded)
      @chat.save

      # 2. update chats_count in app
      ApplicationServices::ApplicationChatsCountIncrementer.new(@chat.application).increment 

      ack! 

    rescue Exception => e 
      # Log the error and reject for reviewal by admin
      puts "Error processing job: #{e.message}"
      
      return reject!
    end
  end
end