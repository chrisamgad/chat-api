module MessageServices
    class MessageGetter
        include MessageHelper

        def initialize(application, chat, number)
            @application = application
            @chat = chat
            @number = number

        end
    
        def get_message


            # retrieve message details from Cache
            cache_key = "application:#{@application.token}:chat:#{@chat.number}:message:#{@number}"
            message_details = CacheService.read_from_cache(cache_key)
            if message_details.empty?
                puts "message_details is empty"
                # if message details are not in Cache, fetch them from MySQL
                begin
                    @message = @chat.messages.find_by!(number: @number)
                rescue ActiveRecord::RecordNotFound
                    return {
                        success: false,
                        message: 'Message not found'
                    }
                end
                
                # store application details in cache for future access
                save_to_cache(@application.token, @chat.number, @message)
                
                # assign application_details to the record fetched from MySQL
                message_details = @message
            else
                # in case the record was found in cache, add the token key to the hash to be included in the final hash result
                message_details["number"] = @number

            end

            return {
                success: true, 
                data: message_details
            }
        end
    end
end