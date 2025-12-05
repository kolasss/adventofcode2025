# frozen_string_literal: true

count = 0
arr1 = File.readlines('input1_1', chomp: true).map do |line|
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

  # p pointer
  # if pointer.negative?
  #   binding.irb
  #   pointer = 99 - (pointer % 99)
  # elsif pointer > 99
  #   pointer %= 99
  # end
  pointer %= 100
  count += 1 if pointer.zero?
  # p "#{dir}, #{val}, #{pointer}, #{count}"
end

# p arr1
p count
