module ChatServices
    class ChatMessageNumberGenerator

        def initialize(chat, application_token, op = "inc")
            @chat = chat
            @application_token = application_token
            @op = op
        end
    
        def generate
            key = "application:#{@application_token}:chat:#{@chat.number}:messages_count"

            new_count = 0

            lock = "#{key}_lock"
            RedisMutex.with_lock(:lock) do
                current_count = REDIS.get(key).to_i
                if current_count.nil?
                    current_count = 0
                end

                if @op == "inc"
                    new_count = current_count + 1
                elsif @op == "dec"
                    new_count = (current_count > 1) ? current_count - 1 : 1
                end
 
                REDIS.set(key, new_count.to_s)
            end

            return new_count
        end
    
    end
end