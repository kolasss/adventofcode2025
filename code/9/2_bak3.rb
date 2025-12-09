# frozen_string_literal: true

# rubocop:disable all

# input_file = 'input1'
input_file = 'input2'
# input_file = 'input_test'

@tiles = []

File.readlines(input_file, chomp: true).map do |line|
  @tiles << line.split(',').map(&:to_i)
end

# pp @tiles

@map = []

def fill_map
  x_max = @tiles.max_by { |tile| tile[0] }[0]
  y_max = @tiles.max_by { |tile| tile[1] }[1]
  # p "x_max: #{x_max}, y_max: #{y_max}"

  @map = Array.new(y_max + 2) { Array.new(x_max + 3, :'0') }
  # p "map size: #{@map.size} x #{@map[0].size}"

  @tiles.each do |tile|
    @map[tile[1]][tile[0]] = :'#'
  end
end

def fill_lines
  @tiles.each_with_index do |tile, index|
    next_tile = @tiles[index + 1]
    next_tile ||= @tiles[0]

    x = tile[0]
    y = tile[1]

    if x == next_tile[0]
      (([y, next_tile[1]].min)..([y, next_tile[1]].max)).each do |yy|
        @map[yy][x] = :X if @map[yy][x] == :'0'
      end
    elsif y == next_tile[1]
      (([x, next_tile[0]].min)..([x, next_tile[0]].max)).each do |xx|
        @map[y][xx] = :X if @map[y][xx] == :'0'
      end
    end
  end
end

DIRECTIONS = [
  [1, 0],
  [0, 1],
  [-1, 0],
  [0, -1]
].freeze

def fill_cell(x, y)
  return if @map.dig(y, x) != :'0'

  @map[y][x] = :'.'

  DIRECTIONS.each do |dir|
    fill_cell(x + dir[0], y + dir[1])
  end
end

def draw_map
  @map.each do |row|
    puts row.join
  end
end

# fill_map
# p 'map_filled'
# # draw_map
# fill_lines
# p 'lines_filled'
# # draw_map
# fill_cell(0, 0)
# p 'cells_filled'
# draw_map

@boundaries_x = {}
@boundaries_y = {}

@coordinates_x = {}
@coordinates_y = {}

@tiles.each do |tile|
  x = tile[0]
  y = tile[1]

  # if @coordinates_x[x]
  #   if y < @coordinates_x[x][0]
  #     @coordinates_x[x][0] = y
  #   elsif y > @coordinates_x[x][1]
  #     @coordinates_x[x][1] = y
  #   end
  # else
  #   @coordinates_x[x] = [y, y]
  # end

  # if @coordinates_y[y]
  #   if x < @coordinates_y[y][0]
  #     @coordinates_y[y][0] = x
  #   elsif x > @coordinates_y[y][1]
  #     @coordinates_y[y][1] = x
  #   end
  # else
  #   @coordinates_y[y] = [x, x]
  # end
  #
  @coordinates_x[x] ||= []
  @coordinates_x[x] << y

  @coordinates_y[y] ||= []
  @coordinates_y[y] << x
end

@coordinates_x.each_value(&:sort!)
@coordinates_y.each_value(&:sort!)

# pp @coordinates_x
# pp @coordinates_y

@coordinates_x.each do |x, ys|
  (ys[0]..ys[-1]).each do |y|
    if @boundaries_y[y]
      if x < @boundaries_y.dig(y, 0)
        @boundaries_y[y][0] = x
      elsif x > @boundaries_y.dig(y, 1)
        @boundaries_y[y][1] = x
      end
    else
      @boundaries_y[y] = [x, x]
    end
  end
end

@coordinates_y.each do |y, xs|
  (xs[0]..xs[-1]).each do |x|
    if @boundaries_x[x]
      if y < @boundaries_x.dig(x, 0)
        @boundaries_x[x][0] = y
      elsif y > @boundaries_x.dig(x, 1)
        @boundaries_x[x][1] = y
      end
    else
      @boundaries_x[x] = [y, y]
    end
  end
end

# pp @boundaries_x
# pp @boundaries_y

@rectangles = {}

def find_rectangle_area(tile1, tile2)
  ((tile1[0] - tile2[0]).abs + 1) * ((tile1[1] - tile2[1]).abs + 1)
end

def save_area(tile1, tile2)
  return if @rectangles[[tile1, tile2]] || @rectangles[[tile2, tile1]]

  area = find_rectangle_area(tile1, tile2)
  @rectangles[[tile1, tile2]] = area
end

def find_opposite_corner_for_left_top(tile1)
  y_max = @boundaries_x.dig(tile1[0], 1)
  opposite_x = @coordinates_y.dig(y_max, 1)

  save_area(tile1, [opposite_x, y_max])
end

def find_opposite_corner_for_left_bottom(tile1)
  y_min = @boundaries_x.dig(tile1[0], 0)
  opposite_x = @coordinates_y.dig(y_min, 1)

  save_area(tile1, [opposite_x, y_min])
end

@coordinates_x.each do |x, ys|
  find_opposite_corner_for_left_top([x, ys[0]])
  find_opposite_corner_for_left_bottom([x, ys[-1]])
end

# pp @rectangles
max = @rectangles.max_by { |_, area| area }
p "max rectangle: #{max.inspect}"
# result = @rectangles.values.max
# p "result: #{result}"

# 24 # test, coords 9,5 and 2,3
# 110020140 # too low
# 110020140
