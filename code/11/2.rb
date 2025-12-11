# frozen_string_literal: true

# input_file = 'input3'
input_file = 'input2'

@devices = {}

File.readlines(input_file, chomp: true).map do |line|
  data = line.split
  @devices[data[0][..-2].to_sym] = data[1..].map(&:to_sym)
end

def count_cached(device, output_device)
  @cached_counts = {}
  count_connected(device, output_device)
end

def count_connected(device, output_device)
  return @cached_counts[device] if @cached_counts.key?(device)
  return 1 if device == output_device
  return 0 if device == :out

  count = 0
  @devices[device].each do |connected_device|
    count += count_connected(connected_device, output_device)
  end
  @cached_counts[device] = count
  count
end

result = count_cached(:svr, :fft) * count_cached(:fft, :dac) * count_cached(:dac, :out)
result += count_cached(:svr, :dac) * count_cached(:dac, :fft) * count_cached(:fft, :out)

# count by code from 1.rb
# svr -> fft = 7920
# fft -> dac = 6662060
# dac -> out = 7314
# result = 7920 * 6662060 * 7314 = 385912350172800

# svr -> dac = 469271495356
# dac -> fft = 0

p "result: #{result}"

# 2 # test
# 385912350172800 # right
