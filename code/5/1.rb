# frozen_string_literal: true

# input_file = 'input1'
input_file = 'input2'

ranges = []
ids = []
ranges_processed = false

File.readlines(input_file, chomp: true).map do |line|
  if ranges_processed
    ids << line.to_i
  elsif line.empty?
    ranges_processed = true
  else
    ranges << line.split('-').map(&:to_i)
  end
end

count = 0

ids.each do |id|
  in_any_range = ranges.any? do |start_num, end_num|
    (start_num..end_num).include?(id)
  end
  count += 1 if in_any_range
end

p "count: #{count}"

# 3 # test
# 840 # right
