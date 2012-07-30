ConvertIphonePng::Application.routes.draw do
  root :to => 'home#index'

  post '/upload' => 'home#upload'
  get '/download-all' => 'home#download_all', as: 'download_all'
end
