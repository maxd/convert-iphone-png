require 'png_converter/png_converter'
require 'png_converter/png_exceptions'

class PngConverter < Paperclip::Processor

  def initialize(file, options = {}, attachment = nil)
    @file = file
    @options = options
    @instance = attachment.instance
    @current_format = File.extname(@file.path)
    @basename = File.basename(@file.path, @current_format)
  end

  def make
    input_png_file = PNGFile.new
    input_png_file.read(@file.path)

    converter = PNGConverter.new
    output_png_file = converter.iphone_png_to_png(input_png_file)

    output_file = Tempfile.new([@basename, @current_format])
    output_png_file.write(output_file)

    output_file
  rescue PNGStandardFormatException
    @file
  end

end