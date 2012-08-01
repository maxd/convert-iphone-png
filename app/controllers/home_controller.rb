require 'securerandom'
require 'zipruby'

class HomeController < ApplicationController

  def index
  end

  def upload
    @group = SecureRandom.hex(16)

    @pictures = []
    params[:files].each do |file|
      case File.extname(file.original_filename).downcase
        when '.png'
          @pictures << Picture.create!({ png_file: file, group: @group, original_file_name: File.basename(file.original_filename)})
        when '.ipa'
          Zip::Archive.open(file.path) do |ar|
            ar.each do |f|
              ext = File.extname(f.name).downcase
              case ext
                when '.png', '.jpg', '.jpeg'
                  temp = Tempfile.new(['picture', ext])
                  temp.binmode
                  f.read { |chunk| temp << chunk }
                  temp.flush

                  @pictures << Picture.create!({png_file: temp, group: @group, original_file_name: File.basename(f.name)})
              end
            end
          end
        else
          @has_ignored_pictures = true
      end
    end

    render :layout => false
  end

  def download_zip
    pictures = nil
    case params[:'download-type']
      when 'all'
        pictures = Picture.where(group: params[:group])
      when 'checked'
        pictures = Picture.where(id: params[:picture_id].map(&:to_i))
    end

    if pictures
      temp = Tempfile.new(%w(all-converted-pictures zip))
      temp.binmode

      Zip::Archive.open(temp.path, Zip::CREATE) do |ar|
        pictures.each_with_index do |picture, index|
          original_file_name = "#{File.basename(picture.original_file_name)}.#{index}#{File.extname(picture.original_file_name)}"
          ar.add_file(original_file_name, picture.png_file.path(:converted))
        end
      end

      send_file temp.path, :type => 'application/zip',
                :disposition => 'attachment',
                :filename => 'all-converted-pictures.zip'

      temp.close
    else
      render text: 'Wrong parameters', status: 404
    end
  end

end
