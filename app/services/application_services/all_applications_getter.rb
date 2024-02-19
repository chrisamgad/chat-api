module ApplicationServices
    class AllApplicationsGetter
    
        def get_applications
            @applications = Application.all

            return {
                success: true, 
                data: @applications
            }
        end
    end
end