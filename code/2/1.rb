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

ranges.each do |range|
  range.each do |i|
    string = i.to_s
    next if string.length.odd?
    next if string[0..((string.length / 2) - 1)] != string[(string.length / 2)..]

    sum += i
  end
end

p "sum: #{sum}"

# 1227775554 # test
# 12850231731 # right
