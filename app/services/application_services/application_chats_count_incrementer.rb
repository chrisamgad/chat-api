module ApplicationServices
    class ApplicationChatsCountIncrementer
        include ApplicationHelper

        def initialize(application)
            @application = application
        end
    
        def increment

            @application.reload.with_lock do
                @application.increment!(:chats_count) # increment record in MySQL
                save_to_cache(@application) # save/update record in cache
            end
            
            rescue Exception => e
                # Handle other errors that may occur during the update
                Rails.logger.error "Error updating chats_count for application #{@application.token}: #{e.message}"
                # Re-raise the error to retry the job
                raise e
        end
    end
end