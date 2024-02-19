module ChatServices
    class ChatGetter
        include ChatHelper

        def initialize(application, number)
            @application = application
            @number = number
        end
    
        def get_chat
            
            # retrieve chat details from Cache
            cache_key = "application:#{@application.token}:chat:#{@number}"
            chat_details = CacheService.read_from_cache(cache_key)

            if chat_details.empty?
                # if chat details are not in Cache, fetch them from MySQL
                begin
                    @chat = @application.chats.find_by!(number: @number)
                rescue ActiveRecord::RecordNotFound
                    return {
                        success: false,
                        message: 'Chat not found'
                    }
                end
    
                # store application details in cache for future access
                save_to_cache(@application.token, @chat)
                
                # assign application_details to the record fetched from MySQL
                chat_details = @chat
            else
                # in case the record was found in cache, add the id to the hash to be included in the final hash result
                chat_details["number"] = @number
            end

            return {
                success: true, 
                data: chat_details.as_json
            }
        end
    end
end