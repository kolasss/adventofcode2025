# frozen_string_literal: true

# rubocop:disable all

# input_file = 'input1'
# input_file = 'input2'
input_file = 'input_test'

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

result = 0

# [
#   [0, 0, 0, 1] x1
#   [0, 1, 0, 1] x2
#   [0, 0, 1, 0] x3
#   [0, 0, 1, 1] x4
#   [1, 0, 1, 0] x5
#   [1, 1, 0, 0] x6
# ]
# [3, 5, 4, 7]
#
# x5 + x6 = 3
# x2 + x6 = 5
# x3 + x4 + x5 = 4
# x1 + x2 + x4 = 7
# This is a system of linear equations that can be solved using linear programming
# or by iterating through possible values to find the minimum sum of button presses.
#
# For a small number of buttons, we can use a brute force approach with constraints.
# For larger systems, consider using a gem like 'matrix' for Gaussian elimination
# or an LP solver.
#
# Since we want the minimum total presses (x1 + x2 + ... + xn), this is a
# linear programming problem with non-negative integer constraints.
# We can use a brute force approach to find the minimum number of button presses.
# Since we need to find non-negative integer solutions that minimize the total presses,
# we'll iterate through possible combinations up to a reasonable limit.

# def solve_system(buttons_normalized, joltage_requirements, max_presses = 100)
#   num_buttons = buttons_normalized.length
#   min_cost = Float::INFINITY
#   best_solution = nil

#   # Generate all combinations of button presses from 0 to max_presses
#   ranges = [0..max_presses] * num_buttons

#   ranges[0].each do |x0|
#     ranges[1].each do |x1|
#       next if num_buttons < 2

#       ranges[2].each do |x2|
#         next if num_buttons < 3

#         # For more buttons, we'd need to adjust this approach
#         # Build the combination array dynamically
#         presses = num_buttons == 2 ? [x0, x1] : [x0, x1, x2]
#         presses += [0] * (num_buttons - presses.length) if num_buttons > 3

#         # If we have more buttons, use a recursive or iterative approach
#         break if num_buttons > 3 # Use alternative method below

#         # Calculate resulting joltage for each requirement
#         result_joltage = Array.new(joltage_requirements.length, 0)
#         presses.each_with_index do |press_count, btn_idx|
#           buttons_normalized[btn_idx].each_with_index do |contrib, req_idx|
#             result_joltage[req_idx] += contrib * press_count
#           end
#         end

#         # Check if this satisfies all requirements
#         next unless result_joltage == joltage_requirements

#         total_presses = presses.sum
#         if total_presses < min_cost
#           min_cost = total_presses
#           best_solution = presses
#         end
#       end
#     end
#   end

#   min_cost == Float::INFINITY ? 0 : min_cost
# end

# Alternative: For systems with any number of buttons, use recursion
def search(buttons, targets, presses, index, current_state, min_cost_ref)
  if index == buttons.length
    if current_state == targets
      total = presses.sum
      min_cost_ref[0] = total if total < min_cost_ref[0]
    end
    return
  end

  (0..100).each do |count|
    new_state = current_state.dup
    buttons[index].each_with_index do |contrib, i|
      new_state[i] += contrib * count
    end

    # Prune if we've exceeded any requirement
    next if new_state.zip(targets).any? { |s, t| s > t }
    # Prune if current presses already exceed known minimum
    next if presses.sum + count >= min_cost_ref[0]

    search(buttons, targets, presses + [count], index + 1, new_state, min_cost_ref)
  end
end

def solve_recursive(buttons_normalized, joltage_requirements)
  num_buttons = buttons_normalized.length

  min_cost = [Float::INFINITY]
  search(buttons_normalized, joltage_requirements, [], 0, Array.new(joltage_requirements.length, 0), min_cost)
  min_cost[0] == Float::INFINITY ? 0 : min_cost[0]
end

def find_button_press_count(machine)
  joltage_requirements = machine[:joltage_requirements]
  buttons = machine[:buttons]
  # state = Array.new(joltage_requirements.length, 0)

  buttons_normalized = buttons.map do |button|
    array = Array.new(joltage_requirements.length, 0)
    button.each do |index|
      array[index] += 1
    end
    array
  end
  # p joltage_requirements
  # p buttons_normalized

  solve_recursive(buttons_normalized, joltage_requirements)
end

@machines.each do |machine|
  result += find_button_press_count(machine)
  p result
end

p "result: #{result}"

# 10 + 12 + 11 = 33 # test
