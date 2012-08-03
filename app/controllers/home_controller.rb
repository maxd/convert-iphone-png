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

      files = {}

      pictures.in_groups_of(40, false) do |group_of_pictures|

        Zip::Archive.open(temp.path, Zip::CREATE) do |ar|
          group_of_pictures.each do |picture|
            extension = File.extname(picture.original_file_name)
            name = File.basename(picture.original_file_name, extension)

            files[picture.original_file_name] ||= 0

            file_name = files[picture.original_file_name] == 0 ? picture.original_file_name : "#{name}.#{files[picture.original_file_name]}#{extension}"
            ar.add_file(file_name, picture.png_file.path(:converted))

            files[picture.original_file_name] += 1
          end
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

  def download_picture
    picture = Picture.find(params[:id])

    send_file picture.png_file.path(:converted), :type => picture.png_file.content_type,
              :disposition => 'attachment',
              :filename => picture.original_file_name
  end

end
