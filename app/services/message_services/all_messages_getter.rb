module MessageServices
    class AllMessagesGetter
        def initialize(chat)
            @chat = chat
        end
    
        def get_all_messages
            @messages = @chat.messages
            return {
                success: true, 
                data: @messages
            }
        end
    end
end