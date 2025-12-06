# frozen_string_literal: true

# input_file = 'input1'
input_file = 'input2'

problems = []

File.readlines(input_file, chomp: true).map do |line|
  problems << line.split.map { _1.match?(/\d/) ? _1.to_i : _1.to_sym }
end

count = 0

COLUMNS = problems[0].length

COLUMNS.times do |col|
  operation = problems[-1][col]
  digits = problems[0..-2].map { _1[col] }
  count += case operation
           when :*
             digits.reduce(1) { |prod, n| prod * n }
           when :+
             digits.sum
           end
end

p "count: #{count}"

# 4277556 # test
# 3261038365331 # right
