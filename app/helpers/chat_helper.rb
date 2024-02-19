module ChatHelper
    def save_to_cache(application_token, chat)
        # Add chat details in cache
        key = "application:#{application_token}:chat:#{@chat.number}"
        data = {
            "messages_count": @chat.messages_count
        }
        CacheService.write_to_cache(key, data)
    end
end