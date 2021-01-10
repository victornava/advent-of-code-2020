require 'test/unit'


def part1(input)
  require_fields = %w[byr iyr eyr hgt hcl ecl pid]
  optinal_fields = %w[cid]

  parse_passport = -> (str) {
    kv_pairs = str.split(/\s+/).map { |str| str.split(":") }
    Hash[kv_pairs]
  }

  is_valid = -> (pass) { (require_fields - pass.keys).size == 0 }

  input
    .split(/\n\n/)
    .map(&parse_passport)
    .select(&is_valid)
    .size
end


def part2(input)
  # cid (Country ID) - ignored, missing or not.

  rules = [
    {
      desc: "byr (Birth Year) - four digits; at least 1920 and at most 2002.",
      fn: -> (pass) {
        val = pass["byr"]
        val && (1920..2002).include?(val.to_i)
      }
    },
    {
      desc: "iyr (Issue Year) - four digits; at least 2010 and at most 2020.",
      fn: -> (pass) {
        val = pass["iyr"]
        val && (2010..2020).include?(val.to_i)
      }
    },
    {
      desc: "eyr (Expiration Year) - four digits; at least 2020 and at most 2030.",
      fn: -> (pass) {
        val = pass["eyr"]
        val && (2020..2030).include?(val.to_i)
      }
    },
    {
      desc: "
        hgt (Height) - a number followed by either cm or in:
          If cm, the number must be at least 150 and at most 193.
          If in, the number must be at least 59 and at most 76.
      ",
      fn: -> (pass) {
        value = pass["hgt"]
        return false unless pass["hgt"]

        match = value.match(/^(\d+)(cm|in)$/)
        return false unless match

        num, unit = match.captures
        if unit == "cm"
          (150..193).include?(num.to_i)
        else
          (59..76).include?(num.to_i)
        end
      }
    },
    {
      desc: "hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.",
      fn: -> (pass) {
        val = pass["hcl"]
        val && val.match(/^#[0-9a-f]{6}$/)
      }
    },
    {
      desc: "ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.",
      fn: -> (pass) {
        val = pass["ecl"]
        val && val.match(/^amb|blu|brn|gry|grn|hzl|oth$/)
      }
    },
    {
      desc: "pid (Passport ID) - a nine-digit number, including leading zeroes.",
      fn: -> (pass) {
        val = pass["pid"]
        val && val.match(/^\d{9}$/)
      }
    },
  ]

  parse_passport = -> (str) do
    pairs = str.split(/\s+/).map { |str| str.split(":") }
    Hash[pairs]
  end

  validate = -> (pass) do
    errors = rules.reject { |rule| rule[:fn].call(pass) }
    return {
      pass: pass,
      errors: errors,
      valid: errors.empty?
    }
  end

  passports = input.split(/\n\n/).map(&parse_passport)
  passports.map(&validate).select {|r| r[:valid] }.size
end

class TheTest < Test::Unit::TestCase
  def test_part1
    assert_equal 2, part1(File.read("example.txt"))
    assert_equal 237, part1(File.read("input.txt"))
  end

  def test_part2
    assert_equal 0, part2(File.read("example.passport-invalid.txt"))
    assert_equal 4, part2(File.read("example.passport-valid.txt"))
    assert_equal 172, part2(File.read("input.txt"))
  end
end
