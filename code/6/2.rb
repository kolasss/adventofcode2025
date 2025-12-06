# frozen_string_literal: true

# input_file = 'input1'
input_file = 'input2'

problems = []

File.readlines(input_file).map do |line|
  problems << line.chars.map do |char|
    if char.match?(/\d/)
      char.to_i
    elsif char.match?(/\s/)
      nil
    else
      char.to_sym
    end
  end
end

count = 0

COLUMNS = problems[0].length

local_array = []
local_operation = nil

def process_column(local_array, operation)
  digits = local_array.map { _1.join.to_i }
  case operation
  when :*
    digits.reduce(1) { |prod, n| prod * n }
  when :+
    digits.sum
  end
end

(COLUMNS + 1).times do |col|
  operation = problems[-1][col]
  local_operation = operation if operation
  column = problems[0..-2].map { _1[col] }
  if column.any?
    local_array << column
  else
    count += process_column(local_array, local_operation)
    local_array = []
  end
end

p "count: #{count}"

# 3263827 # test
# 8342588849093 # right
