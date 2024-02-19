class ApplicationSerializer
    def self.serialize(application)
        if application.is_a?(Hash)
            {
              token: application["token"],
              name: application["name"],
              chats_count: application["chats_count"]
            }.as_json
        elsif application.is_a?(ActiveRecord::Base)
            {
              token: application.token,
              name: application.name,
              chats_count: application.chats_count
            }.as_json
        elsif application.respond_to?(:to_ary)
            application.map do |record|
              {
                token: record.token,
                name: record.name,
                chats_count: record.chats_count
              }.as_json
            end
        else
            raise ArgumentError, "Unsupported application format"
        end
    end
end
