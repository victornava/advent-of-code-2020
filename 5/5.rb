require 'test/unit'

def part1(input)
  boarding_passes = input.split(/\n/)
  boarding_passes
    .map { |bp| decode(bp)[:seat_id] }
    .max
end

def part2(input)
  boarding_passes = input.split(/\n/)
  seats = boarding_passes.map { |bp| decode(bp) }
  seat_ids = seats.map { |seat| seat[:seat_id] }
  all_seats = (seat_ids.min..seat_ids.max).to_a
  (all_seats - seat_ids).first # Pure luck?  
end

def decode(str)
  row_steps = str[0..6].chars.map { |c| c == "F" ? :lower : :upper }
  col_steps = str[7..].chars.map { |c| c == "L" ? :lower : :upper }

  row = binary_partition(min: 0, max: 127, steps: row_steps)
  column = binary_partition(min: 0, max: 7, steps: col_steps)
  seat_id = (row * 8) + column

  {
    row: row,
    column: column,
    seat_id: seat_id,
  }
end

def binary_partition(min:, max:, steps:)
  steps.each do |step|
    case step
    when :lower
      max = min + (max - min) / 2
    when :upper
      min = max - (max - min) / 2
    else
      raise "ERROR: Step must be :lower or :upper"
    end
  end
  steps.last == :lower ? min : max
end

class TheTest < Test::Unit::TestCase
  def test_decode
    assert_equal decode("FBFBBFFRLR"), { row: 44, column: 5, seat_id: 357 }
    assert_equal decode("BFFFBBFRRR"), { row: 70, column: 7, seat_id: 567 }
    assert_equal decode("FFFBBBFRRR"), { row: 14, column: 7, seat_id: 119 }
    assert_equal decode("BBFFBBFRLL"), { row: 102, column: 4, seat_id: 820 }
  end

  def test_part1
    assert_equal 906, part1(File.read("input.txt"))
  end

  def test_part2
    assert_equal 519, part2(File.read("input.txt"))
  end
end
