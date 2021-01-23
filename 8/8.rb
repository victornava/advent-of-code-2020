require 'test/unit'

def part1(input)
  program = parse(input)
  acc, status = evaluate(program)
  acc
end

def part2(input)
  program = parse(input)

  program.each_with_index do |inc, i|
    op, arg = inc

    if op == "jmp" || op == "nop"
      new_program = program.clone

      if op == "jmp"
        new_program[i] = ["nop", arg]
      elsif op == "nop"
        new_program[i] = ["jmp", arg]
      end

      acc, status = evaluate(new_program)

      return acc if status == :ok
    end
  end
end

def parse(input)
  input
    .split(/\n/)
    .map { |l| [ l.split[0], l.split[1].to_i ] }
end

def evaluate(program)
  executed = [] # Instructions already executed
  ip = 0 # Instruction Pointer
  acc = 0 # Accumulator

  loop do
    if executed.include?(ip)
      return acc, :infinite_loop
    elsif program[ip].nil?
      return acc, :ok
    end

    op, arg = program[ip]
    executed << ip

    case op
    when "acc"
      acc += arg
      ip += 1
    when "jmp"
      ip += arg
    when "nop"
      ip += 1
    else
      raise "🔥 #{ip} #{program[ip]}"
    end
  end
end

class TheTest < Test::Unit::TestCase
  def test_part1
    assert_equal 5, part1(File.read("example.txt"))
    assert_equal 1451, part1(File.read("input.txt"))
  end

  def test_part2
    assert_equal 8, part2(File.read("example.txt"))
    assert_equal 1160, part2(File.read("input.txt"))
  end
end
