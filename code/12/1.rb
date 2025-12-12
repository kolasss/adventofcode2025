# frozen_string_literal: true

# input_file = 'input1'
input_file = 'input2'

PRESENT_SIZE = 3
@presents = []
@regions = []

present_started = false
present = []
File.readlines(input_file, chomp: true).map do |line|
  if line.match?(/^\d+:/)
    present_started = true
  elsif present_started && line.empty?
    present_started = false
    @presents << present
    present = []
  elsif present_started && !line.empty?
    present << line.chars.map { |c| c == '#' }
  elsif line.match?(/\d+x\d+:/)
    region_size, presents = line.split(':')
    width, height = region_size.split('x').map(&:to_i)
    @regions << { width: width, height: height, presents: presents.split.map(&:to_i) }
  end
end

# pp @presents
# pp @regions

def print_grid(grid)
  grid.each do |row|
    puts row.map { |cell| cell ? '#' : '.' }.join
  end
  puts
end

# this doesn't actually try to place the presents, just checks area
# doesn't work for test input, but works for real input
def valid_region?(region)
  presents = region[:presents].map.with_index { |count, index| [@presents[index]] * count }.flatten(1)

  grid_size = region[:width] * region[:height]
  presents_area = presents.sum { |p| p.flatten.count(true) }
  presents_area <= grid_size
end

count = 0

@regions.each do |region|
  count += 1 if valid_region?(region)
end

puts "result: #{count}"

# 2 # test
# 587 # right
