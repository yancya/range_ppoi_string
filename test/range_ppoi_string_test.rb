require "test-unit"
require "range_ppoi_string"

class RangePpoiStringTest < Test::Unit::TestCase
  using RangePpoiString

  data(
    1 => [[*1..3, 5, 7], "1-3,5,7"],
    2 => [[], ""],
    3 => [[*?a..?c, ?z], "a-c,z"],
    "unsorted input" => [[3, 1, 2, 5, 7], "1-3,5,7"],
    "duplicated input" => [[1, 1, 2, 3, 3, 5, 7], "1-3,5,7"],
    "unsorted and duplicated input" => [[7, 3, 1, 5, 2, 1, 3], "1-3,5,7"],
  )
  test "to_s" do |(actual, expected)|
    assert { actual.to_s == expected }
  end

  data(
    1 => ["1-3,5,7", %w{1 2 3 5 7}],
    2 => ["", []],
    3 => ["a-c,z", %w{a b c z}]
  )
  test "to_a" do |(actual, expected)|
    assert { actual.to_a == expected }
  end

  test "to_s raises NoNextError instead of recursing when elements don't respond to next" do
    assert_raise(RangePpoiString::NoNextError) { [1.5, 2.5].to_s }
  end

  data(
    "reversed range" => "3-1",
    "empty segment between commas" => ",,1",
    "trailing dash" => "abc-",
    "leading dash (non-numeric)" => "-abc",
  )
  test "to_a raises ParseError on malformed input" do |input|
    assert_raise(RangePpoiString::ParseError) { input.to_a }
  end

  data(
    "negative single value" => ["-3", ["-3"]],
    "negative to negative range" => ["-3--1", %w{-3 -2 -1}],
    "negative to positive range" => ["-2-1", %w{-2 -1 0 1}],
  )
  test "to_a round-trips negative integers" do |(input, expected)|
    assert { input.to_a == expected }
  end

  test "negative integer array round-trips through to_s and to_a" do
    array = [-3, -2, -1, 5]
    assert { array.to_s == "-3--1,5" }
    assert { array.to_s.to_a == array.map(&:to_s) }
  end
end

class RangePpoiStringModuleApiTest < Test::Unit::TestCase
  # Deliberately no `using RangePpoiString` here: this class proves the
  # module functions work without the refinements active.

  test "dump converts an array to a range ppoi string" do
    assert { RangePpoiString.dump([*1..3, 5, 7]) == "1-3,5,7" }
  end

  test "parse converts a range ppoi string to an array" do
    assert { RangePpoiString.parse("1-3,5,7") == %w{1 2 3 5 7} }
  end

  test "dump raises NoNextError for elements without next" do
    assert_raise(RangePpoiString::NoNextError) { RangePpoiString.dump([1.5, 2.5]) }
  end

  test "parse raises ParseError for malformed input" do
    assert_raise(RangePpoiString::ParseError) { RangePpoiString.parse("3-1") }
  end

  test "dump and parse round-trip negative integers identically to the refinements" do
    array = [-3, -2, -1, 5]
    assert { RangePpoiString.dump(array) == "-3--1,5" }
    assert { RangePpoiString.parse(RangePpoiString.dump(array)) == array.map(&:to_s) }
  end
end
