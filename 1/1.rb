require 'test/unit'

def report_repair(input, n=2)
  input
    .each_line
    .map { |l| l.strip.to_i }
    .combination(n)
    .select { |xs| xs.reduce(&:+) == 2020 }
    .map { |xs| xs.reduce(&:*) }
    .first
end

class TheTest < Test::Unit::TestCase
  def test_report_repair
    input = File.read("input.txt")
    example = File.read("example.txt")

    # Part 1
    assert_equal 514579, report_repair(example)
    assert_equal 542619, report_repair(input)
    
    # Part 2
    assert_equal 241861950, report_repair(example, 3)
    assert_equal 32858450, report_repair(input, 3)
  end
end
