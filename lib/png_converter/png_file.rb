require 'png_signature'
require 'png_chunk'
require 'png_exceptions'
require 'png_file_verbose'

class PNGFile

  include PNGFileVerbose

  def initialize(chunks = nil)
    if chunks
      @signature = PNGSignature.new
      @chunks = chunks
    end
  end

  def read(file)
    input = file.kind_of?(IO) ? file : File.open(file, 'rb')

    @signature = PNGSignature.new
    @signature.read(input)
    raise PNGIncorrectSignatureException.new("Incorrect signature of PNG file.") unless @signature.is_valid

    @chunks = []

    until input.eof?
      chunk = PNGChunk.new
      chunk.read(input)
      @chunks << chunk
    end
  end

  def write(file)
    output = file.kind_of?(IO) ? file : File.open(file, 'wb')

    @signature.write(output)
    @chunks.each do |chunk|
      chunk.write(output)
    end

    output.flush
  end

  def signature
    @signature
  end

  def chunks(type = nil)
    type ? @chunks.select {|c| c.type == type} : @chunks
  end

end