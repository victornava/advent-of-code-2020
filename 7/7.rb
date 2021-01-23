require 'test/unit'

def part1(node, input)
  edges = make_edges(input)
  nodes_to(node, edges).size
end

def part2(node, input)
  edges = make_edges(input)
  calc(node, edges)
end

# Transform the input string into a list of graph edges.
# input:
#   light red bags contain 1 bright white bag, 2 muted yellow bags.
# output:
#   [ { form: "light red", to: "bright white", count: 1 },
#     { form: "light red", to: "muted yellow", count: 2 } ]
def make_edges(input)
  edges = []
  input.each_line do |line|
    from, rest = line.strip.split(" bags contain ")
    rest.split(",").each do |str|
      next if str.include?("no other")
      count, to = str.match(/(\d+)\s(.*)\sbags?.?/).captures
      edges << { from: from, to: to, count: count.to_i }
    end
  end
  edges
end

# Find nodes that point to node directly or indirectly.
# Equivalent of findind the ancestors of a node in a tree
def nodes_to(node, edges, bag=[])
  edges.each do |e|
    if e[:to] == node && !bag.include?(e[:from])
      bag << e[:from]
      bag + nodes_to(e[:from], edges, bag)
    end
  end
  bag
end

# Does that part 2 needs to do :P
def calc(node, edges)
  edges
    .select { |e| e[:from] == node }
    .sum { |e| e[:count] + (e[:count] * calc(e[:to], edges)) }
end

class TheTest < Test::Unit::TestCase
  def test_part1
    assert_equal 4, part1("shiny gold", File.read("example.txt"))
    assert_equal 348, part1("shiny gold", File.read("input.txt"))
  end

  def test_part2
    assert_equal 32, part2("shiny gold", File.read("example.txt"))
    assert_equal 18885, part2("shiny gold", File.read("input.txt"))
  end
end
