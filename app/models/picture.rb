class Picture < ActiveRecord::Base
  attr_accessible :wrong, :png_file

  has_attached_file :png_file,
                    styles: { converted: '', thumb: '200x160>' },
                    convert_options: { thumb: '-gravity center -background none -extent 210x170 ' },
                    processors: [ :png_converter, :thumbnail ],
                    url: '/system/png-files/:hash-:style.:extension',
                    hash_secret: 'abacadae'

  validates_attachment :png_file,
                       presence: true,
                       content_type: { content_type: 'image/png' }
end
