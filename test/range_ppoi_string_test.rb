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
end
