# frozen_string_literal: true

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

result = 0

def press_button(state, button)
  new_state = state.dup
  button.each do |index|
    new_state[index] = !new_state[index]
  end
  new_state
end

def find_buttons_to_press(state, diagram, buttons)
  return [] if state == diagram

  difference_indexes = state.each_index.reject { |i| state[i] == diagram[i] }
  buttons.select { |button| (button & difference_indexes).any? }.shuffle
end

def process_variant(variant, diagram, buttons)
  new_state = press_button(variant[:state], variant[:variant])
  new_depth = variant[:depth] + 1
  return new_depth if new_state == diagram

  new_variants = find_buttons_to_press(new_state, diagram, buttons - variant[:pressed_buttons])
  pressed_buttons = variant[:pressed_buttons] + [variant[:variant]]
  new_variants.each do |new_variant|
    @variants_queue << {
      variant: new_variant,
      state: new_state,
      depth: new_depth,
      pressed_buttons: pressed_buttons
    }
  end
  nil
end

def find_button_press_count(machine)
  diagram = machine[:diagram]
  buttons = machine[:buttons]
  state = Array.new(diagram.length, false)

  variants = find_buttons_to_press(state, diagram, buttons)
  @variants_queue = variants.map do |variant|
    {
      variant: variant,
      state: state,
      depth: 0,
      pressed_buttons: []
    }
  end

  while @variants_queue.any?
    variant = @variants_queue.shift
    result = process_variant(variant, diagram, buttons)
    return result if result
  end
end

@machines.each do |machine|
  result += find_button_press_count(machine)
  p result
end

p "result: #{result}"

# 2 + 3 + 2 = 7 # test
# 520 # right
