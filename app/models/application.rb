class Application < ApplicationRecord
    include Tokenable
    validates :name, presence: true

    has_many :chats
end
