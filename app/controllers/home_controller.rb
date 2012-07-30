require 'securerandom'
require 'zip/zip'

class HomeController < ApplicationController

  def index
  end

  def upload
    @group = SecureRandom.hex(16)

    @pictures = params[:files].map do |file|
      Picture.create!({ png_file: file, group: @group }) if File.extname(file.original_filename) == '.png'
    end.compact

    @has_ignored_pictures = params[:files].length != @pictures.length

    render :layout => false
  end

  def download_all
    unless params[:group].blank?
      pictures = Picture.where(group: params[:group])

      temp = Tempfile.new(%w(all-converted-pictures zip))

      Zip::ZipOutputStream.open(temp.path) do |z|
        pictures.each do |picture|
          z.put_next_entry picture.png_file_file_name
          z.write IO.read(picture.png_file.path(:converted))
        end
      end

      send_file temp.path, :type => 'application/zip',
                :disposition => 'attachment',
                :filename => 'all-converted-pictures.zip'

      temp.close
    else
      render text: 'Wrong group', status: 404
    end
  end

end
