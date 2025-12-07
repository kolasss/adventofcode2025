# frozen_string_literal: true

# input_file = 'input1'
input_file = 'input2'
# input_file = 'input_test'

@map = []

File.readlines(input_file, chomp: true).map do |line|
  @map << line.chars.map(&:to_sym)
end

COLUMNS = @map[0].length

def next_step(row_index, col_index)
  cached_value = @cache.dig(row_index, col_index)
  return cached_value if cached_value

  count = count_paths(row_index, col_index)
  @cache[row_index] ||= {}
  @cache[row_index][col_index] = count
  count
end

def count_paths(row_index, col_index)
  next_row = @map[row_index]
  return 1 unless next_row

  count = 0
  case next_row[col_index]
  when :'.'
    count = next_step(row_index + 1, col_index)
  when :^
    count += next_step(row_index + 1, col_index - 1) if col_index - 1 >= 0
    count += next_step(row_index + 1, col_index + 1) if col_index + 1 < COLUMNS
  end
  count
end

count = 0
@cache = {}
@map[0].each_with_index do |char, index|
  next unless char == :S

  count = next_step(1, index)
end

p "count: #{count}"

# 40 # test
# 221371496188107 # right
