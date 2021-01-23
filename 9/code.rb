require 'test/unit'

def part1(input, preamble_size)
  ns = input.split(/\n/).map(&:to_i)
  ns[preamble_size..-1].each_with_index.each do |n, i|
    preamble = ns.slice(i, preamble_size)
    pairs = preamble.permutation(2)
    if pairs.select { |pair| n == pair.sum }.size < 2
      return n
    end
  end
end

def part2(input, target)
  ns = input.split(/\n/).map(&:to_i)
  ns.size.times do |i|
    sum = 0
    xs = ns[i..-1].take_while do |n|
      sum += n
      sum < target
    end
    if sum == target
      return xs.minmax.sum
    end
  end
end

class TheTest < Test::Unit::TestCase
  def test_part1
    assert_equal 127, part1(File.read("example.txt"), 5)
    assert_equal 57195069, part1(File.read("input.txt"), 25)
  end

  def test_part2
    assert_equal 62, part2(File.read("example.txt"), 127)
    assert_equal 7409241, part2(File.read("input.txt"), 57195069)
  end
end
