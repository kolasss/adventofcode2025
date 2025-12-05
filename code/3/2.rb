# frozen_string_literal: true

sum = 0
# input_file = 'input1'
input_file = 'input2'

banks = []
File.readlines(input_file, chomp: true).map do |line|
  banks << line.chars.map(&:to_i)
end

banks.each do |bank|
  digits = []
  min_index = 0
  12.times do |i|
    slice = bank[min_index..(-12 + i)]
    max = slice.max
    min_index = slice.index(max) + min_index + 1
    digits << max
  end
  sum += digits.join.to_i
end

p "sum: #{sum}"

# 3121910778619 # test
# 171846613143331 # right
