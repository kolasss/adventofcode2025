# frozen_string_literal: true

count = 0
arr1 = File.readlines('input2', chomp: true).map do |line|
  [line[0].to_sym, line[1..].to_i]
end

pointer = 50

arr1.each do |dir, val|
  case dir
  when :L
    pointer -= val
  when :R
    pointer += val
  end

  pointer %= 100
  count += 1 if pointer.zero?
end

p count

# 1100 # right
