# frozen_string_literal: true

# rubocop:disable all

input_file = 'input1'
# input_file = 'input2'
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

result = 0

def press_button(state, button)
  new_state = state.dup
  button.each do |index|
    new_state[index] += 1
  end
  new_state
end

def find_buttons_to_press(state, joltage_requirements, buttons)
  return [] if state == joltage_requirements

  difference_indexes = state.each_index.select { |i| state[i] < joltage_requirements[i] }
  difference_index_min = difference_indexes.min_by { |i| joltage_requirements[i] }
  equal_indexes = state.each_index.select { |i| state[i] == joltage_requirements[i] }
  buttons.select { |button| button.include?(difference_index_min) && (button & equal_indexes).empty? }.shuffle
end

def process_variant(variant, joltage_requirements, buttons)
  new_state = press_button(variant[:state], variant[:variant])
  # p new_state
  return if new_state.each_index.any? { |i| new_state[i] > joltage_requirements[i] }

  new_depth = variant[:depth] + 1
  return new_depth if new_state == joltage_requirements

  new_variants = find_buttons_to_press(new_state, joltage_requirements, buttons)
  # pressed_buttons = [variant[:pressed_buttons][-1], variant[:variant]].compact
  new_variants.each do |new_variant|
    @variants_queue << {
      variant: new_variant,
      state: new_state,
      depth: new_depth
      # pressed_buttons: pressed_buttons
    }
  end
  nil
end

# def map_buttons(length, buttons)
#   indexes = Array.new(length) { [] }
#   buttons.each do |button|
#     button.each do |index|
#       indexes[index] << button
#     end
#   end
#   indexes
# end

def find_button_press_count(machine)
  joltage_requirements = machine[:joltage_requirements]
  buttons = machine[:buttons]
  state = Array.new(joltage_requirements.length, 0)

  # button_map = map_buttons(joltage_requirements.length, buttons)
  # p button_map
  variants = find_buttons_to_press(state, joltage_requirements, buttons)
  @variants_queue = variants.map do |variant|
    {
      variant: variant,
      state: state,
      depth: 0
      # pressed_buttons: []
    }
  end

  while @variants_queue.any?
    variant = @variants_queue.shift
    result = process_variant(variant, joltage_requirements, buttons)
    return result if result
  end
end

@machines.each do |machine|
  result += find_button_press_count(machine)
  p result
end

p "result: #{result}"

# 10 + 12 + 11 = 33 # test
