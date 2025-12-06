# frozen_string_literal: true

# input_file = 'input1'
input_file = 'input2'

ranges = []

File.readlines(input_file, chomp: true).map do |line|
  break if line.empty?

  ranges << line.split('-').map(&:to_i)
end

def union_ranges(min1, max1, min2, max2)
  [[min1, min2].min, [max1, max2].max]
end

def update_ranges(ranges, index, new_range)
  ranges[index - 1] = new_range
  ranges.delete_at(index)
end

def compact_ranges(ranges)
  compacted = false
  ranges.sort_by! { |min, _max| min }
  ranges.each_with_index do |(min, max), index|
    next if index.zero?

    previous_range = ranges[index - 1]
    next unless min.between?(previous_range[0], previous_range[1])

    new_range = union_ranges(previous_range[0], previous_range[1], min, max)
    update_ranges(ranges, index, new_range)
    compacted = true
  end
  return compact_ranges(ranges) if compacted

  ranges
end

compact_ranges(ranges)

count = 0
ranges.each do |min, max|
  count += (max - min + 1)
end

p "count: #{count}"

# 14 # test
# 359913027576322 # right
