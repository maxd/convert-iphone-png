class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :original_file_name
      t.attachment :png_file
      t.string :group, null: false

      t.timestamps
    end
  end
end
