# frozen_string_literal: true

# input_file = 'input1'
# CONNECTIONS = 10
input_file = 'input2'
CONNECTIONS = 1000

@boxes = []

File.readlines(input_file, chomp: true).map do |line|
  @boxes << line.split(',').map(&:to_i)
end

# pp @boxes

@lengths = {}

# d = √((x₂ - x₁)² + (y₂ - y₁)² + (z₂ - z₁)²)
def find_length_between(box1, box2)
  Math.sqrt(((box2[0] - box1[0])**2) + ((box2[1] - box1[1])**2) + ((box2[2] - box1[2])**2))
end

@boxes.each do |box|
  @boxes.each do |other_box|
    next if box == other_box

    next if @lengths.dig(box, other_box)

    length = find_length_between(box, other_box)
    @lengths[box] ||= {}
    @lengths[box][other_box] = length
    @lengths[other_box] ||= {}
    @lengths[other_box][box] = length
  end
end

# pp @lengths

@lengths_sorted = []
@lengths.each do |box, lengths_hash|
  lengths_hash.each do |other_box, length|
    @lengths_sorted << [box, other_box, length]
  end
end
@lengths_sorted.sort_by! { |item| item[2] }
# pp @lengths_sorted

@circuits = {}
@circuits_ids = {}
@latest_circuit_id = 1

def find_circuit_id(box1, box2)
  circuit_id1 = @circuits_ids[box1]
  return circuit_id1 if circuit_id1

  circuit_id2 = @circuits_ids[box2]
  return circuit_id2 if circuit_id2

  @latest_circuit_id += 1
  @latest_circuit_id
end

def assign_circuit(box, circuit_id)
  old_circuit_id = @circuits_ids[box]

  @circuits[circuit_id] ||= Set.new

  if old_circuit_id && old_circuit_id != circuit_id
    # Merge circuits
    @circuits[old_circuit_id].each do |old_box|
      @circuits_ids[old_box] = circuit_id
      @circuits[circuit_id] << old_box
    end
    @circuits.delete(old_circuit_id)
  else
    @circuits_ids[box] = circuit_id
    @circuits[circuit_id] << box
  end
end

CONNECTIONS.times do
  shortest = @lengths_sorted.shift
  box1 = shortest[0]
  box2 = shortest[1]

  index = @lengths_sorted.index([box2, box1, shortest[2]])
  @lengths_sorted.delete_at(index) if index

  circuit_id = find_circuit_id(box1, box2)
  assign_circuit(box1, circuit_id)
  assign_circuit(box2, circuit_id)
end

# pp @circuits_ids

longest = @circuits.max_by(3) { |_circuit_id, boxes| boxes.size }.map { |_circuit_id, boxes| boxes.size }
# p "longest: #{longest}"

result = longest.reduce(:*)
p "result: #{result}"

# 40 # test
# 8 # wrong
# 81536 # right
