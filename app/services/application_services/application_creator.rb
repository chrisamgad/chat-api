module ApplicationServices
    class ApplicationCreator
        include ApplicationHelper

        def initialize(name:)
            @name = name
        end
    
        def create_app
            @application = Application.create!(
                name: @name
            )

            save_to_cache(@application)

            return {
                success: true, 
                data: @application
            }

            rescue ActiveRecord::RecordInvalid => invalid
                return {
                    success: false, 
                    message: invalid.record.errors.full_messages[0]
                }
        end

        
    end
end