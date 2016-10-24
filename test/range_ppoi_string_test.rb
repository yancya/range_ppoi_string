require "test-unit"
require "range_ppoi_string"

class RangePpoiStringTest < Test::Unit::TestCase
  using RangePpoiString

  data(
    1 => [[*1..3, 5, 7], "1-3,5,7"],
    2 => [[], ""],
    3 => [[*?a..?c, ?z], "a-c,z"]
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
