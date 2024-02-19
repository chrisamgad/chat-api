class Message < ApplicationRecord
    validates :chat_id, presence: true
    validates :number, presence: true

    belongs_to :chat   

    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    index_name self.name.downcase.pluralize # index name


    # define custom elasticsearch settings and mappings for the Message model
    settings index: { number_of_shards: 1 } do
        mapping dynamic: false do
            indexes :chat_id, type: :long
            indexes :content, type: :text, analyzer: "standard"
        end
    end

    # create index in case it wasn't created
    __elasticsearch__.client.indices.create(
        index: index_name,
        body: { settings: settings.to_hash, mappings: mappings.to_hash }
    ) unless __elasticsearch__.client.indices.exists?(index: index_name)
  

    # search messages in chat
    def self.search_in_chat(search_params)
        params = {
            query: {
                bool: {
                    must: [
                        { match: { content: "*#{search_params[:search_query]}*" } }
                    ],
                    filter: [
                        { term: { chat_id: search_params[:chat_id] } }
                    ]
                }
            }
        }

        @messages = __elasticsearch__.search(params).records.to_a
      end
end
