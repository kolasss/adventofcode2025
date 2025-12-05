# frozen_string_literal: true

sum = 0
# input_file = 'input1'
input_file = 'input2'

ranges = []
File.readlines(input_file, chomp: true).map do |line|
  [line[0].to_sym, line[1..].to_i]
  line.split(',').each do |range|
    start_str, end_str = range.split('-')
    ranges << (start_str.to_i..end_str.to_i)
  end
end
# p ranges

def fake_id?(id)
  arr = id.to_s.chars.map(&:to_i)
  return false if arr.tally.values.any? { |v| v < 2 }

  (1..(arr.length / 2)).each do |i|
    chunks = split_into_chunks(arr, i)
    first = chunks[0]
    not_equal = chunks[1..].any? do |element|
      element != first
    end
    # all_equal = chunks.uniq.length == 1
    next if not_equal

    # p id
    # p i
    # p first
    return true
  end
  false
end

def split_into_chunks(array, chunk_size)
  chunks = []
  ((array.length / chunk_size) + 1).times do |i|
    next unless array[i * chunk_size]

    chunks << array[i * chunk_size, chunk_size]
  end
  chunks
end
# binding.irb

ranges.each do |range|
  range.each do |i|
    sum += i if fake_id?(i)
  end
end

p "sum: #{sum}"

# 4174379265 # test
# 24774350322 # right

# Benchmark results: all?
# "sum: 24774350322"
# real	0m 11.20s
# user	0m 10.81s
# sys	0m 0.38s

# Benchmark results: uniq
# "sum: 24774350322"
# real	0m 14.09s
# user	0m 13.93s
# sys	0m 0.16s

# Benchmark results: tally
# "sum: 24774350322"
# real	0m 3.41s
# user	0m 3.39s
# sys	0m 0.02s
