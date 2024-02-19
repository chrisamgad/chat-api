Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do 
    namespace :v1 do
      resources :applications, param: :token ,only: %i[index show create update search] do
        resources :chats, param: :number ,only: %i[index show create update] do
          resources :messages, param: :number ,only: %i[index show create update search] do
            collection do
              get 'search'
            end
          end
        end
      end
    end  
  end
end