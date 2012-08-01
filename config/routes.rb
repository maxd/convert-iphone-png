ConvertIphonePng::Application.routes.draw do
  root :to => 'home#index'

  post '/upload' => 'home#upload'
  post '/download-zip' => 'home#download_zip', as: 'download_zip'
end
