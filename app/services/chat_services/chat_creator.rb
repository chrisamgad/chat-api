module ChatServices
    class ChatCreator
        include ChatHelper

        def initialize(application)
            @application = application
        end
    
        def create_chat
    
            @chat = Chat.new(
                application_id: @application.id,
                number: ApplicationServices::ApplicationChatNumberGenerator.new(@application).generate,
                messages_count: 0
            )

            if !@chat.valid?
                ApplicationServices::ApplicationChatNumberGenerator.new(@application, "dec").generate # reverse operation
                return {
                    success: false,
                    message: @chat.errors.full_messages[0]
                }
            end

            # perform later saving the chat in DB and incrementing the chats_count
            Publisher.publish(ENV["CHATS_QUEUE"], @chat)

            return {
                success: true,
                data: @chat
            }
        end
    end
end