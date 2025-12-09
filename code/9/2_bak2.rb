# frozen_string_literal: true

# rubocop:disable all

# input_file = 'input1'
# input_file = 'input2'
input_file = 'input_test'

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

  # (0..(y_max + 1)).each do |y|
  #   row = (0..(x_max + 2)).map do |x|
  #     if @tiles.include?([x, y])
  #       :'#'
  #     else
  #       :'0'
  #     end
  #   end
  #   @map << row
  # end
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

fill_map
p 'map_filled'
# draw_map
fill_lines
p 'lines_filled'
# draw_map
fill_cell(0, 0)
p 'cells_filled'
draw_map

@rectangles = {}

def find_rectangle_area(tile1, tile2)
  ((tile1[0] - tile2[0]).abs + 1) * ((tile1[1] - tile2[1]).abs + 1)
end

def save_area(tile1, tile2)
  return if @rectangles[[tile1, tile2]] || @rectangles[[tile2, tile1]]

  area = find_rectangle_area(tile1, tile2)
  @rectangles[[tile1, tile2]] = area
end

def find_max_x(tile)
  x = tile[0]
  y = tile[1]

  x_max = x
  loop do
    x_next = x_max + 1
    break if @map.dig(y, x_next) == :'.'

    x_max = x_next
  end

  x_max
end

def find_max_y_for_x(tile, x_max)
  x = tile[0]
  y = tile[1]

  y_max = y
  loop do
    y_next = y_max + 1
    break if @map[y_next].slice(x..x_max).any? { |cell| cell == :'.' }

    y_max = y_next
  end

  y_max
end

def find_tiles_right_and_bottom(tile)
  x = tile[0]
  y = tile[1]
  other_tiles = Set.new

  x_max = find_max_x(tile)
  y_max = find_max_y_for_x(tile, x_max)

  x_start = x + ((x_max - x) / 2)
  y_start = y + ((y_max - y) / 2)
  range_x = x_start..x_max
  range_y = y_start..y_max

  @tiles.each do |other_tile|
    if range_x.include?(other_tile[0]) && range_y.include?(other_tile[1]) && other_tile != tile
      other_tiles << other_tile
    end
  end
  other_tiles
end

def find_max_y(tile)
  x = tile[0]
  y = tile[1]

  y_max = y
  loop do
    y_next = y_max + 1
    break if @map.dig(y_next, x) == :'.'

    y_max = y_next
  end

  y_max
end

def find_max_x_for_y(tile, y_max)
  x = tile[0]
  y = tile[1]

  x_max = x
  slice = @map.slice(y..y_max)
  loop do
    x_next = x_max + 1
    break if slice.map { _1[x_next] }.any? { |cell| cell == :'.' }

    x_max = x_next
  end

  x_max
end

def find_tiles_bottom_and_right(tile)
  x = tile[0]
  y = tile[1]
  other_tiles = Set.new

  y_max = find_max_y(tile)
  x_max = find_max_x_for_y(tile, y_max)

  x_start = x + ((x_max - x) / 2)
  y_start = y + ((y_max - y) / 2)
  range_x = x_start..x_max
  range_y = y_start..y_max

  @tiles.each do |other_tile|
    if range_x.include?(other_tile[0]) && range_y.include?(other_tile[1]) && other_tile != tile
      other_tiles << other_tile
    end
  end
  other_tiles
end

@tiles.each do |tile|
  other_tiles = find_tiles_right_and_bottom(tile) + find_tiles_bottom_and_right(tile)

  other_tiles.each do |other_tile|
    save_area(tile, other_tile)
  end
end

# pp @rectangles
max = @rectangles.max_by { |_, area| area }
p "max rectangle: #{max.inspect}"
# result = @rectangles.values.max
# p "result: #{result}"

# 24 # test, coords 9,5 and 2,3
# 110020140 # too low
# 110020140
