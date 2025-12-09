# frozen_string_literal: true

# input_file = 'input1'
input_file = 'input2'
# input_file = 'input_test'

@tiles = []

File.readlines(input_file, chomp: true).map do |line|
  @tiles << line.split(',').map(&:to_i)
end

@lines = []

@tiles.each_with_index do |tile, index|
  next_tile = @tiles[index + 1]
  next_tile ||= @tiles[0]

  @lines << [tile, next_tile]
end

@rectangles = {}

def find_rectangle_area(tile1, tile2)
  ((tile1[0] - tile2[0]).abs + 1) * ((tile1[1] - tile2[1]).abs + 1)
end

def rectangle_crosses_any_line?(tile1, tile2) # rubocop:disable Metrics/AbcSize
  x_min = [tile1[0], tile2[0]].min
  x_max = [tile1[0], tile2[0]].max
  y_min = [tile1[1], tile2[1]].min
  y_max = [tile1[1], tile2[1]].max

  @lines.any? do |line_start, line_end|
    if line_start[0] == line_end[0]
      crosses_vertical_line?(x_min, x_max, y_min, y_max, line_start, line_end)
    else
      crosses_horizontal_line?(x_min, x_max, y_min, y_max, line_start, line_end)
    end
  end
end

def crosses_vertical_line?(x_min, x_max, y_min, y_max, line_start, line_end) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/ParameterLists
  line_x = line_start[0]
  line_y_min = [line_start[1], line_end[1]].min
  line_y_max = [line_start[1], line_end[1]].max

  line_x > x_min && line_x < x_max && (
    (line_y_min <= y_min && line_y_max > y_min) ||
    (line_y_min > y_min && line_y_max < y_max) ||
    (line_y_max >= y_max && line_y_min < y_max))
end

def crosses_horizontal_line?(x_min, x_max, y_min, y_max, line_start, line_end) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/ParameterLists
  line_y = line_start[1]
  line_x_min = [line_start[0], line_end[0]].min
  line_x_max = [line_start[0], line_end[0]].max

  line_y > y_min && line_y < y_max && (
    (line_x_min <= x_min && line_x_max > x_min) ||
    (line_x_min > x_min && line_x_max < x_max) ||
    (line_x_max >= x_max && line_x_min < x_max))
end

def save_area(tile1, tile2)
  return if @rectangles[[tile1, tile2]] || @rectangles[[tile2, tile1]]
  return if tile1[0] == tile2[0] || tile1[1] == tile2[1]
  return if rectangle_crosses_any_line?(tile1, tile2)

  area = find_rectangle_area(tile1, tile2)
  @rectangles[[tile1, tile2]] = area
end

@tiles.combination(2).each do |tile1, tile2|
  save_area(tile1, tile2)
end

# pp @rectangles
# max = @rectangles.max_by { |_, area| area }
# p "max rectangle: #{max.inspect}"
result = @rectangles.values.max
p "result: #{result}"

# 24 # test, coords 9,5 and 2,3
# 110020140 # too low
# 1613305596 # right
