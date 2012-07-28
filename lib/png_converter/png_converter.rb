require 'zlib'
require 'png_chunk_types'
require 'png_exceptions'

class PNGConverter

  def iphone_png_to_png(png_file)
    if png_file.chunks(PNGChunkTypes::CgBI).empty?
      raise PNGStandardFormatException.new("PNG file isn't in iPhone format.")
    else
      width = 0
      chunks = []

      last_idat_chunk = png_file.chunks(PNGChunkTypes::IDAT).last

      in_zstream = Zlib::Inflate.new(-Zlib::MAX_WBITS)
      out_zstream = Zlib::Deflate.new

      png_file.chunks.each do |chunk|
        if chunk.type == PNGChunkTypes::IHDR
          width = chunk.width
        end

        if chunk.type == PNGChunkTypes::IDAT
          data = in_zstream.inflate(chunk.data)
          data = swap_colors(data, width)
          data = out_zstream.deflate(data, last_idat_chunk == chunk ? Zlib::FINISH : nil)

          chunk = PNGChunk.new(chunk.type, data)
        end

        chunks << chunk if chunk.type != PNGChunkTypes::CgBI
      end

      in_zstream.finish
      in_zstream.close

      out_zstream.close

      PNGFile.new(chunks)
    end
  end

  def swap_colors(data, width)
    row_index = 0

    loop do
      1.step(width * 4, 4) do |col|
        tmp = data[row_index + col]
        data[row_index + col] = data[row_index + col + 2]
        data[row_index + col + 2] = tmp
      end

      row_index += (4 * width + 1)
      break if row_index >= data.length
    end

    data
  end

end