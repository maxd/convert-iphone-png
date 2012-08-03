class ZipCreator

  BATCH_SIZE = 40 # Batch required to avoid 'to many open files' exception

  def self.from_pictures(pictures)
    temp = Tempfile.new(%w(all-converted-pictures .zip))
    temp.binmode

    files = {}

    pictures.in_groups_of(BATCH_SIZE, false) do |group_of_pictures|
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

    temp
  end

end