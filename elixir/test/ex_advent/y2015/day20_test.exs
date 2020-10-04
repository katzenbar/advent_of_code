defmodule ExAdvent.Y2015.Day20Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day20

  test "divisors - 1" do
    assert divisors(1) == [1]
  end

  test "divisors - 2" do
    assert divisors(2) == [1, 2]
  end

  test "divisors - 12" do
    assert divisors(12) == [1, 2, 3, 4, 6, 12]
  end

  test "divisors - 16" do
    assert divisors(16) == [1, 2, 4, 8, 16]
  end

  test "presents_delivered_to_house_pt1 - 1" do
    assert presents_delivered_to_house_pt1(1) == 10
  end

  test "presents_delivered_to_house_pt1 - 7" do
    assert presents_delivered_to_house_pt1(7) == 80
  end

  test "presents_delivered_to_house_pt1 - 8" do
    assert presents_delivered_to_house_pt1(8) == 150
  end

  test "lowest_house_with_num_presents_pt1 - 90" do
    assert lowest_house_with_num_presents_pt1(90) == 6
  end

  test "lowest_house_with_num_presents_pt2 - 120" do
    assert lowest_house_with_num_presents_pt2(120) == 6
  end
end
