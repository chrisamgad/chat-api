module MessageServices
    class MessageCreator
        include MessageHelper

        def initialize(application, chat, content)
            @application = application
            @chat = chat
            @content = content
        end
    
        def create_message
            
            @message = Message.new(
                chat_id: @chat.id,
                number: ChatServices::ChatMessageNumberGenerator.new(@chat, @application.token).generate,
                content: @content
            )

            if !@message.valid?
                ChatServices::ChatMessageNumberGenerator.new(@chat, @application.token, "dec").generate # reverse operation
                return {
                    success: false,
                    message: @message.errors.full_messages[0]
                }
            end

            # perform later saving the message in DB and incrementing the messages_count
            Publisher.publish(ENV["MESSAGES_QUEUE"], @message)

            return {
                success: true,
                data: @message
            }
        end
    end
end