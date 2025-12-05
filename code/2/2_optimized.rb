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

def fake_id?(id) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity
  arr = id.to_s.chars.map(&:to_i)
  len = arr.length
  return false if arr.tally.values.any? { |v| v < 2 }

  (1..(len / 2)).each do |chunk_size|
    next unless (len % chunk_size).zero?

    pattern = arr[0, chunk_size]
    is_repeating = true
    (chunk_size...len).step(chunk_size) do |start|
      if arr[start, chunk_size] != pattern
        is_repeating = false
        break
      end
    end
    return true if is_repeating
  end
  false
end

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

# Benchmark results: optimized by Claude Opus 4.5
# "sum: 24774350322"
# real	0m 3.33s
# user	0m 3.31s
# sys	0m 0.01s
