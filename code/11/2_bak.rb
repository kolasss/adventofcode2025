# frozen_string_literal: true

# rubocop:disable all

# input_file = 'input3'
input_file = 'input2'

@devices = {}

File.readlines(input_file, chomp: true).map do |line|
  data = line.split
  @devices[data[0][..-2].to_sym] = data[1..].map(&:to_sym)
end

@cached_paths = {}

@count = 0
# @paths = []

def count_connected(device, path = [])
  p device
  # p @cached_paths

  paths_out = []

  if @cached_paths.key?(device)
    p 'cached'
    cached_paths = @cached_paths[device]

    # p cached_paths
    cached_paths.each do |cached_path|
      # device_index = cached_path.index(device)
      # paths_out << (path + cached_path[device_index..])
      new_path = path + cached_path
      # @paths << new_path
      if new_path.include?(:dac) && new_path.include?(:fft)
        @count += 1
      else
        p 'not included'
        # p new_path.count
        # p new_path.uniq.count
      end
      paths_out << new_path
    end
    p 'cached done'
  else
    new_path = path + [device]

    if device == :out
      # @paths << new_path
      p new_path
      @count += 1 if new_path.include?(:dac) && new_path.include?(:fft)
      return new_path
    end

    @devices[device].each do |connected_device|
      paths_out << count_connected(connected_device, new_path)
    end

    @cached_paths[device] = paths_out.map { |p| p - path }
  end

  paths_out
end

count_connected(:svr)

# p @paths
# result = @paths.count { |path| path.include?(:dac) && path.include?(:fft) }

# p "result: #{result}"
p "result: #{@count}"

# 2 # test
