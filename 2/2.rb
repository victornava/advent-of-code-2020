require 'test/unit'

def part1(input)
  input
    .each_line
    .map { |l| l.split(":").map(&:strip) }
    .select do |policy, pass|
      min_max, char = policy.split(" ")
      min, max = min_max.split("-").map(&:to_i)
      char_count = pass.chars.tally[char]
      char_count && char_count >= min && char_count <= max
    end
    .size
end

def part2(input)
  input
    .each_line
    .map { |l| l.split(":").map(&:strip) }
    .select do |policy, pass|
      positions, char = policy.split(" ")
      p1, p2 = positions.split("-").map { |x| x.to_i - 1 }
      (pass.chars[p1] == char ) ^ (pass.chars[p2] == char)
    end
    .size
end

class TheTest < Test::Unit::TestCase
  def test_part1
    example = File.read("example.txt")
    assert_equal 2, part1(example)

    input = File.read("input.txt")
    assert_equal 467, part1(input)
  end

  def test_part2
    example = File.read("example.txt")
    assert_equal 1, part2(example)

    input = File.read("input.txt")
    assert_equal 441, part2(input)
  end
end
