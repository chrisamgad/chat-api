module MessageServices
    class MessageUpdater
        include MessageHelper

        def initialize(application, chat, message, content)
            @application = application
            @chat = chat
            @message = message
            @content = content
        end
    
        def update_message
            begin
                @message.content = @content
                @message.save!
            rescue ActiveRecord::RecordInvalid => invalid
                return {
                    success: false, 
                    message: invalid.record.errors.full_messages[0]
                }
            end

            @message.__elasticsearch__.index_document # update elastic search index

            save_to_cache(@application.token, @chat.number, @message) # update cache
 
            return {
                success: true, 
                data: @message
            }
        end
    end
end