class PNGInterlaceMethod0

  def initialize(width, height)
    @width = width
    @height = height

    @data_tail = ''
  end

  def process_data(data)
    data, @data_tail = align_data_by_width(@width, data, @data_tail)
    swap_colors(data, @width)
  end

  def align_data_by_width(width, data, data_tail)
    data = data_tail + data

    tail_length = data.length % row_size(width)

    [data[0, data.length - tail_length], data[-tail_length, tail_length]]
  end

  def swap_colors(data, width)
    row_index = 0

    while row_index < data.length do
      1.step(width * 4, 4) do |col|
        tmp = data[row_index + col]
        data[row_index + col] = data[row_index + col + 2]
        data[row_index + col + 2] = tmp
      end

      row_index += row_size(width)
    end

    data
  end

  def size(width, height)
    row_size(width) * height
  end

  def row_size(width)
    4 * width + 1
  end

end