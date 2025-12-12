# frozen_string_literal: true

# Implementation of solution for problem 10, part 2
# https://www.reddit.com/r/adventofcode/comments/1pk87hl/2025_day_10_part_2_bifurcate_your_way_to_victory/

# input_file = 'input1'
input_file = 'input2'
# input_file = 'input_test'

@machines = []

File.readlines(input_file, chomp: true).map do |line|
  data = line.split
  @machines << {
    diagram: data[0].chars[1..-2].map { |c| c == '#' },
    buttons: data[1..-2].map { |text| text[1..-2].split(',').map(&:to_i) },
    joltage_requirements: data[-1][1..-2].split(',').map(&:to_i)
  }
end

# pp @machines

def map_buttons(length, buttons)
  buttons.map do |button|
    (0...length).map { |i| button.include?(i) ? 1 : 0 }
  end
end

# Generate all possible patterns of button presses and their costs(number of presses)
def generate_patterns(buttons)
  out = {}
  num_buttons = buttons.length
  num_variables = buttons[0].length

  (0..num_buttons).each do |pattern_len|
    (0...num_buttons).to_a.combination(pattern_len).each do |buttons_indexes|
      # p btns
      # Sum up the coefficients for selected buttons
      pattern = sum_buttons(buttons, buttons_indexes, num_variables)

      out[pattern] ||= pattern_len
    end
  end

  out
end

def sum_buttons(buttons, buttons_indexes, num_variables)
  pattern = Array.new(num_variables, 0)
  buttons_indexes.each do |i|
    buttons[i].each_with_index do |val, j|
      pattern[j] += val
    end
  end
  pattern
end

def solve_aux(current_goal)
  return 0 if current_goal.all?(&:zero?)

  return @cache[current_goal] if @cache.key?(current_goal)

  answer = Float::INFINITY

  @pattern_costs.each do |pattern, pattern_cost|
    new_answer = count_goal_cost(current_goal, pattern, pattern_cost)
    next unless new_answer

    answer = new_answer if new_answer < answer
  end

  @cache[current_goal] = answer
  answer
end

def count_goal_cost(current_goal, pattern, pattern_cost)
  zipped = pattern.zip(current_goal)
  # Check if pattern is valid: i <= j and same parity
  valid = zipped.all? do |i, j|
    i <= j && (i % 2) == (j % 2)
  end
  return unless valid

  new_goal = zipped.map { |i, j| (j - i) / 2 }.freeze
  pattern_cost + (2 * solve_aux(new_goal))
end

def find_button_press_count_min(machine)
  joltage_requirements = machine[:joltage_requirements]
  # convert to binary representation
  buttons = map_buttons(joltage_requirements.length, machine[:buttons])
  # pp buttons

  @pattern_costs = generate_patterns(buttons)
  # pp pattern_costs
  # pp pattern_costs.length

  @cache = {}

  solve_aux(joltage_requirements)
end

result = 0

@machines.each do |machine|
  result += find_button_press_count_min(machine)
  # p result
end
# result = find_button_press_count_min(@machines[0])

p "result: #{result}"

# 10 + 12 + 11 = 33 # test
# 20626 # right
