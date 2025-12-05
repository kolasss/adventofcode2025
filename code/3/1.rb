# frozen_string_literal: true

sum = 0
# input_file = 'input1'
input_file = 'input2'

banks = []
File.readlines(input_file, chomp: true).map do |line|
  banks << line.chars.map(&:to_i)
end

banks.each do |bank|
  sorted = bank.sort
  first = sorted[-1]
  index = bank.index(first)
  if index == bank.length - 1
    first = sorted[-2]
    index = bank.index(first)
  end

  second = bank[(index + 1)..].max
  sum += "#{first}#{second}".to_i
end

p "sum: #{sum}"

# 357 # test
# 17324 # right
