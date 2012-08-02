class PNGInterlaceMethod1

  def initialize(width, height)
    @width = width
    @height = height

    @interlace_pass = 0
    @interlace_size = 0

    @data_tail = ''
  end

  def process_data(data)
    position = 0

    data = @data_tail + data

    while @interlace_pass < 7 do
      interlace_width, interlace_height = adam7_pass_size(@interlace_pass, @width, @height)

      data, position = swap_colors(data, interlace_width, interlace_height, position) if interlace_width != 0 and interlace_height != 0

      if @interlace_size == size(interlace_width, interlace_height) or (interlace_width == 0 or interlace_height == 0)
        @interlace_pass += 1
        @interlace_size = 0
      else
        break
      end
    end

    @data_tail = data[position, data.length - position]
    data[0, position]
  end

  def swap_colors(data, width, height, position)
    row_index = position

    while (row_index + row_size(width) <= data.length) and (@interlace_size < size(width, height)) do
      1.step(4 * width, 4) do |col|
        tmp = data[row_index + col]
        data[row_index + col] = data[row_index + col + 2]
        data[row_index + col + 2] = tmp
      end

      row_index += row_size(width)
      @interlace_size += row_size(width)
    end

    [data, row_index]
  end

  def adam7_pass_size(pass, original_width, original_height)
    x_multiplier = 8 >> (pass >> 1)
    x_offset = (pass & 1 == 0) ? 0 : 8 >> ((pass + 1) >> 1)
    y_multiplier = pass == 0 ? 8 : 8 >> ((pass - 1) >> 1)
    y_offset = (pass == 0 || pass & 1 == 1) ? 0 : 8 >> (pass >> 1)

    [ ((original_width - x_offset ) / x_multiplier.to_f).ceil,
      ((original_height - y_offset ) / y_multiplier.to_f).ceil]
  end

  def size(width, height)
    row_size(width) * height
  end

  def row_size(width)
    4 * width + 1
  end

end