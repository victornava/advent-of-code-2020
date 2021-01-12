require 'test/unit'

def part1(input)
  input.split(/^\n/).sum do |group|
    group.scan(/[a-z]/).uniq.size
  end
end

def part2(input)
  groups = input.split(/^\n/)

  groups.sum do |group|
    group_size = group.strip.split(/\n+/).size
    group
      .scan(/[a-z]/)
      .tally
      .select { |_, v| v == group_size }
      .size
  end
end

class TheTest < Test::Unit::TestCase
  def test_part1
    assert_equal 11, part1(File.read("example.txt"))
    assert_equal 7120, part1(File.read("input.txt"))
  end

  def test_part2
    assert_equal 6, part2(File.read("example.txt"))
    assert_equal 3570, part2(File.read("input.txt"))
  end
end