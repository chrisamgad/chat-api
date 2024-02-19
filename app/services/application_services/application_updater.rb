module ApplicationServices
    class ApplicationUpdater
        include ApplicationHelper

        def initialize(application, name)
            @application = application
            @name = name
        end
    
        def update_app
        
            begin
                @application.name = @name
                @application.save!
            rescue ActiveRecord::RecordInvalid => invalid
                return {
                    success: false, 
                    message: invalid.record.errors.full_messages[0]
                }
            end

            save_to_cache(@application)
 
            return {
                success: true, 
                data: @application
            }
        end
    end
end