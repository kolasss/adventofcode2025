# frozen_string_literal: true

# input_file = 'input1'
input_file = 'input2'

@devices = {}

File.readlines(input_file, chomp: true).map do |line|
  data = line.split
  @devices[data[0][..-2].to_sym] = data[1..].map(&:to_sym)
end

# pp @devices

@cached_counts = {}

def count_connected(device)
  return @cached_counts[device] if @cached_counts.key?(device)
  return 1 if device == :out

  count = 0
  @devices[device].each do |connected_device|
    count += count_connected(connected_device)
  end
  @cached_counts[device] = count
  count
end

result = count_connected(:you)

p "result: #{result}"

# 5 # test
# 506 # right
