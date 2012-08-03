namespace :app do

  desc 'Remove old pictures'
  task clean_pictures: :environment do
    Picture.where('created_at < ?', 2.hours.ago).destroy_all
  end

end