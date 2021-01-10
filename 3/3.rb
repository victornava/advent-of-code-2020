require 'test/unit'

def part1(input, right:, down:)
  lines = input.split("\n")
  width = lines.first.size
  tree_count = 0
  x = 0
  y = 0

  loop do
    # Move y
    y += down
    line = lines[y]

    if line.nil?
      break
    end

    # Move x wrapping when x >= width
    x = (x + right) % width
    item = line[x]

    if item == "#"
      tree_count += 1
    end
  end

  tree_count
end

def part1_functional(input, right:, down:)
  matrix = input.split("\n").map(&:chars)
  xs = (right..).step(right)

  (down..)
    .step(down)
    .take_while { |y| y < matrix.size }
    .map { |y| matrix[y].rotate(xs.next).first }
    .select { |x| x == "#" }
    .size
end

def part2(input, slopes)
  slopes.reduce(1) do |memo, slope|
    memo * part1(input, right: slope[:right], down: slope[:down])
  end
end

class TheTest < Test::Unit::TestCase
  def test_part1
    assert_equal 7, part1(File.read("example.txt"), right: 3, down: 1)
    assert_equal 162, part1(File.read("input.txt"), right: 3, down: 1)
    assert_equal 162, part1_functional(File.read("input.txt"), right: 3, down: 1)
  end

  def test_part2
    slopes = [
      { right: 1, down: 1 },
      { right: 3, down: 1 },
      { right: 5, down: 1 },
      { right: 7, down: 1 },
      { right: 1, down: 2 }
    ]

    assert_equal 336, part2(File.read("example.txt"), slopes)
    assert_equal 3064612320, part2(File.read("input.txt"), slopes)
  end
end
