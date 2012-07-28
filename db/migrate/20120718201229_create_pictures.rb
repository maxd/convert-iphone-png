class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.attachment :png_file
      t.boolean :wrong

      t.timestamps
    end
  end
end
