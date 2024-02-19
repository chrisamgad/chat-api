module MessageServices
    class SearchService
        include MessageHelper

        def initialize(chat, query)
            @chat = chat
            @query = query

        end
    
        def search
                        
            search_by_object = {
                chat_id: @chat.id,
                search_query: @query
            }
            
            @messages = Message.search_in_chat(search_by_object)

            return {
                success: true, 
                data: @messages
            }
        end
    end
end