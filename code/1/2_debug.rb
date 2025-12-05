# frozen_string_literal: true

count = 0
# input_file = 'input1'
input_file = 'input2'
# input_file = 'input_test'
arr1 = File.readlines(input_file, chomp: true).map do |line|
  [line[0].to_sym, line[1..].to_i]
end

pointer = 50

def new_pointer(pointer, dir, val, count)
  case dir
  when :L
    val.times do
      pointer -= 1
      if pointer.zero?
        count += 1
      elsif pointer.negative?
        pointer = 99
      end
    end
  when :R
    val.times do
      pointer += 1
      if pointer > 99
        pointer = 0
        count += 1
      end
    end
  end

  [pointer, count]
end

arr2 = []
arr3 = []
count3 = 0
pointer3 = 50
arr1.each do |dir, val|
  old_pointer = pointer
  case dir
  when :L
    pointer -= val
  when :R
    pointer += val
  end

  p pointer
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

  pointer3, count3 = new_pointer(pointer3, dir, val, count3)

  p "#{dir}, #{val}, pointer: #{pointer}, count: #{count}"
  arr2 << [dir, val, pointer, count]
  arr3 << [dir, val, pointer3, count3]
  break if [dir, val, pointer, count] != [dir, val, pointer3, count3]
end

File.open('output2', 'w') do |file|
  arr2.each do |row|
    file << "#{row.join(', ')}\n"
  end
end
File.open('output3', 'w') do |file|
  arr3.each do |row|
    file << "#{row.join(', ')}\n"
  end
end

p "count: #{count}"

# 6255 # too low
# 6358 # right
