module MessageHelper
    def save_to_cache(application_token, chat_number, message)
        # Add message details in cache
        key = "application:#{application_token}:chat:#{chat_number}:message:#{@message.number}"
        data = {
            "content": @message.content
        }
        CacheService.write_to_cache(key, data)
    end
end