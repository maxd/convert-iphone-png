class Picture < ActiveRecord::Base
  attr_accessible :png_file, :group

  has_attached_file :png_file,
                    styles: { converted: '' },
                    processors: [ :png_converter ],
                    url: '/system/png-files/:hash-:style.:extension',
                    hash_secret: 'abacadae'

  validates_attachment :png_file,
                       presence: true,
                       content_type: { content_type: 'image/png' }
end
