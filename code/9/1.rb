# frozen_string_literal: true

# input_file = 'input1'
input_file = 'input2'

@tiles = []

File.readlines(input_file, chomp: true).map do |line|
  @tiles << line.split(',').map(&:to_i)
end

# pp @tiles

@rectangles = {}

def find_rectangle_area(tile1, tile2)
  ((tile1[0] - tile2[0]).abs + 1) * ((tile1[1] - tile2[1]).abs + 1)
end

def save_area(tile1, tile2)
  return if @rectangles[[tile1, tile2]] || @rectangles[[tile2, tile1]]

  area = find_rectangle_area(tile1, tile2)
  @rectangles[[tile1, tile2]] = area
end

@tiles.combination(2).each do |tile1, tile2|
  save_area(tile1, tile2)
end

# pp @rectangles
result = @rectangles.values.max
p "result: #{result}"

# 50 # test
# 4755064176 # right
