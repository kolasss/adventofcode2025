# frozen_string_literal: true

count = 0
# input_file = 'input1'
input_file = 'input2'
# input_file = 'input_test'
arr1 = File.readlines(input_file, chomp: true).map do |line|
  [line[0].to_sym, line[1..].to_i]
end

pointer = 50

arr1.each do |dir, val|
  old_pointer = pointer
  case dir
  when :L
    pointer -= val
  when :R
    pointer += val
  end

  if pointer.zero?
    count += 1
  elsif pointer.negative?
    rotates = (pointer / 100).abs
    # binding.irb
    count += rotates
    count -= 1 if old_pointer.zero?
    count += 1 if (pointer % 100).zero?
  else
    rotates = (pointer / 100)
    count += rotates
  end
  pointer %= 100

  # p "#{dir}, #{val}, pointer: #{pointer}, count: #{count}"
end

p "count: #{count}"

# 6255 # too low
# 6358 # right
