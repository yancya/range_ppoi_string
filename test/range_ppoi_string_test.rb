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
end
