class HomeController < ApplicationController

  def index
  end

  def upload
    @pictures = params[:files].map do |file|
      Picture.create!({ png_file: file }) if File.extname(file.original_filename) == '.png'
    end.compact

    render :layout => false
  end

end
