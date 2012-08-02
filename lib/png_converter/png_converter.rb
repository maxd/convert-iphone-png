require 'zlib'
require 'png_chunk_types'
require 'png_exceptions'
require 'png_interlace_method_0'
require 'png_interlace_method_1'

class PNGConverter

  def iphone_png_to_png(png_file)
    if png_file.chunks(PNGChunkTypes::CgBI).empty?
      raise PNGStandardFormatException.new("PNG file isn't in iPhone format.")
    else
      interlace_method = nil
      chunks = []

      last_idat_chunk = png_file.chunks(PNGChunkTypes::IDAT).last

      in_zstream = Zlib::Inflate.new(-Zlib::MAX_WBITS)
      out_zstream = Zlib::Deflate.new

      png_file.chunks.each do |chunk|
        if chunk.type == PNGChunkTypes::IHDR
          width = chunk.width
          height = chunk.height
          case chunk.interlace_method
            when 0
              interlace_method = PNGInterlaceMethod0.new(width, height)
            when 1
              interlace_method = PNGInterlaceMethod1.new(width, height)
            else
              raise PNGException.new('Unknown interlace method')
          end
        end

        if chunk.type == PNGChunkTypes::IDAT
          data = in_zstream.inflate(chunk.data)

          data = interlace_method.process_data(data)

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

end