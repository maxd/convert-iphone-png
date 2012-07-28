module PNGHeaderChunk

  def width
    @data[0..3].unpack('N').first
  end

  def height
    @data[4..7].unpack('N').first
  end

  def bit_depth
    @data[8].unpack('C').first
  end

  def colour_type
    @data[9].unpack('C').first
  end

  def compression_method
    @data[10].unpack('C').first
  end

  def filter_method
    @data[11].unpack('C').first
  end

  def interlace_method
    @data[12].unpack('C').first
  end

end