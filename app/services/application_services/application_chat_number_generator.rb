module ApplicationServices
    class ApplicationChatNumberGenerator

        def initialize(application, op = "inc")
            @application = application
            @op = op
        end
    
        def generate
            key = "application:#{@application.token}:chats_count"
            
            lock = "#{key}_lock"
            new_count = 0
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