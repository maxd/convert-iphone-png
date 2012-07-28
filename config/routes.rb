ConvertIphonePng::Application.routes.draw do
  root :to => 'home#index'

  post '/upload' => 'home#upload'
end
