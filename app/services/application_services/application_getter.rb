module ApplicationServices
    class ApplicationGetter
        include ApplicationHelper

        def initialize(token)
            @token = token
        end
    
        def get_app
           
            # retrieve application details from Cache
            cache_key = "application:#{@token}"
            application_details = CacheService.read_from_cache(cache_key)

            if application_details.empty?
                # if application details are not in Cache, fetch them from MySQL
                begin
                    @application = Application.find_by!(token: @token)
                rescue ActiveRecord::RecordNotFound
                    return {
                        success: false,
                        message: 'Application not found'
                    }
                end
                
                # store application details in cache for future access
                save_to_cache(@application)
                
                # assign application_details to the record fetched from MySQL
                application_details = @application
            else
                # in case the record was found in cache, add the token key to the hash to be included in the final hash result
                application_details[:token] = @token
            end


            return {
                success: true, 
                data: application_details.as_json
            }
        end
    end
end