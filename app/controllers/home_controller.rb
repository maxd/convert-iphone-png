class HomeController < ApplicationController

  def index
  end

  def upload
    @pictures = params[:files].map do |file|
      case File.extname(file.original_filename)
        when '.png'
          Picture.create!({ png_file: file })
        when '.ipa'
      end
    end

    render :layout => false
  end

end
