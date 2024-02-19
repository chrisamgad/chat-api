class Chat < ApplicationRecord
    validates :application_id, presence: true
    validates :number, presence: true

    belongs_to :application   
    has_many :messages

end
