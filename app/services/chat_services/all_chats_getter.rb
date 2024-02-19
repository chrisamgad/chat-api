module ChatServices
    class AllChatsGetter
        def initialize(application)
            @application = application
        end
    
        def get_all_chats

            @chats = @application.chats

            return {
                success: true, 
                data: @chats
            }
        end
    end
end