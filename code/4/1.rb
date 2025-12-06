# frozen_string_literal: true

# input_file = 'input1'
input_file = 'input2'

@map = []
File.readlines(input_file, chomp: true).map do |line|
  @map << line.chars.map(&:to_sym)
end

def draw_map
  @map.each do |row|
    puts row.join
  end
end

# draw_map

DIRECTIONS = [
  [1, 0],
  [1, -1],
  [0, -1],
  [-1, -1],
  [-1, 0],
  [-1, 1],
  [0, 1],
  [1, 1]
].freeze
ROWS = @map.size
COLS = @map[0].size
PAPER = %i[@ x].freeze

def can_access?(x, y)
  return false if @map[y][x] != :'@'

  count = 0
  DIRECTIONS.each do |dx, dy|
    count += 1 if paper?(x + dx, y + dy)
  end
  return false if count >= 4

  @map[y][x] = :x
  true
end

def paper?(x, y)
  return false if x.negative? || x >= COLS
  return false if y.negative? || y >= ROWS

  PAPER.include?(@map.dig(y, x))
end

count = 0

ROWS.times do |x|
  COLS.times do |y|
    count += 1 if can_access?(x, y)
  end
end

# p '-' * 30
# draw_map

p "count: #{count}"

# 13 # test
# 1397 # right
