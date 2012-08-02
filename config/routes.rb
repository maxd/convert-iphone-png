ConvertIphonePng::Application.routes.draw do
  root :to => 'home#index'

  post '/upload' => 'home#upload'
  post '/download-zip' => 'home#download_zip', as: 'download_zip'
  get '/download-picture/:id' => 'home#download_picture', as: 'download_picture'
end
