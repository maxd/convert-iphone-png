require 'zlib'
require 'png_chunk_types'
require 'png_header_chunk'

class PNGChunk

  def initialize(type = nil, data = nil)
    if type and data
      @type = type
      @data = data
      @length = @data.length
      @crc = Zlib::crc32(type + data, 0)
    end
  end

  def read(input)
    @length = input.read(4).unpack('N').first
    @type = input.read(4)
    @data = input.read(@length)
    @crc = input.read(4).unpack('N').first

    case @type
      when PNGChunkTypes::IHDR
        extend PNGHeaderChunk
    end
  end

  def write(output)
    output.write([@length].pack('N'))
    output.write(@type)
    output.write(@data)
    output.write([@crc].pack('N'))
  end

  def length
    @length
  end

  def type
    @type
  end

  def data
    @data
  end

  def crc
    @crc
  end

end