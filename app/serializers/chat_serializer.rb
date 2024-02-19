class ChatSerializer
    def self.serialize(chat)
        if chat.is_a?(Hash)
            {
                number: chat["number"],
                messages_count: chat["messages_count"]
            }.as_json
        elsif chat.is_a?(ActiveRecord::Base)
            {
                number: chat.number,
                messages_count: chat.messages_count
            }.as_json
        elsif chat.respond_to?(:to_ary)
            chat.map do |record|
              {
                number: record.number,
                messages_count: record.messages_count
              }.as_json
            end
        else
            raise ArgumentError, "Unsupported chat format"
        end
    end
end
