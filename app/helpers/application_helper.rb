module ApplicationHelper
    def save_to_cache(application)
        # Add application details in cache
        key = "application:#{@application.token}"
        data = {
            "name": @application.name,
            "chats_count": @application.chats_count
        }
        CacheService.write_to_cache(key, data)
    end
end