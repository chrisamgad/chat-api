module ChatServices
    class ChatMessagesCountIncrementer
        include ChatHelper

        def initialize(chat)
            @chat = chat
        end
    
        def increment

            @chat.reload.with_lock do
                @chat.increment!(:messages_count)
                save_to_cache(@chat.application.token, @chat) # save/update record in cache
            end
            
            rescue StandardError => e
                # Handle other errors that may occur during the update
                Rails.logger.error "Error updating messages_count for application #{@chat.id}: #{e.message}"
                # Re-raise the error to retry the job
                raise e
        end
    end
end