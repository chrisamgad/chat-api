class MessageSerializer
    def self.serialize(message)
        if message.is_a?(Hash)
            {
                number: message["number"],
                content: message["content"]
            }.as_json
        elsif message.is_a?(ActiveRecord::Base)
            {
                number: message.number,
                content: message.content
            }.as_json
        elsif message.respond_to?(:to_ary)
            message.map do |record|
              {
                number: record.number,
                content: record.content
              }.as_json
            end
        else
            raise ArgumentError, "Unsupported message format"
        end   
    end
end
