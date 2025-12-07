# frozen_string_literal: true

# input_file = 'input1'
input_file = 'input2'

@map = []

File.readlines(input_file, chomp: true).map do |line|
  @map << line.chars.map(&:to_sym)
end

# def draw_map
#   @map.each do |row|
#     puts row.join(' ')
#   end
# end

# draw_map

BEAMS = %i[S |].freeze
COLUMNS = @map[0].length
count = 0

@map.each_with_index do |row, row_index|
  next_row = @map[row_index + 1]
  next unless next_row

  # p row
  row.each_with_index do |char, col|
    next unless BEAMS.include?(char)

    # p next_row[col]
    splitted = false
    if next_row[col] == :'.'
      next_row[col] = :|
    elsif next_row[col] == :^
      if col.positive? && next_row[col - 1] == :'.'
        next_row[col - 1] = :|
        splitted = true
      end
      if col < COLUMNS - 1 && next_row[col + 1] == :'.'
        next_row[col + 1] = :|
        splitted = true
      end
    end

    count += 1 if splitted
  end
end

# p '-' * 30
# draw_map

p "count: #{count}"

# 21 # test
# 1690 # right
