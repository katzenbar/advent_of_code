defmodule ExAdvent.Y2015.Day12Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day12

  test "sum_json_numbers - empty array" do
    assert sum_json_numbers(~s([])) == 0
  end

  test "sum_json_numbers - empty map" do
    assert sum_json_numbers(~s({})) == 0
  end

  test "sum_json_numbers - simple map" do
    assert sum_json_numbers(~s({"a":2,"b":4})) == 6
  end

  test "sum_json_numbers - simple array" do
    assert sum_json_numbers(~s([1,2,3])) == 6
  end

  test "sum_json_numbers - nested array" do
    assert sum_json_numbers(~s([[[3]]])) == 3
  end

  test "sum_json_numbers - nested map" do
    assert sum_json_numbers(~s({"a":{"b":4},"c":-1})) == 3
  end

  test "sum_json_numbers - array with map" do
    assert sum_json_numbers(~s([-1,{"a":1}])) == 0
  end

  test "sum_json_numbers - map with array" do
    assert sum_json_numbers(~s({"a":[-1,1]})) == 0
  end

  test "sum_json_numbers - mixed array" do
    assert sum_json_numbers(~s([1,"a",2])) == 3
  end

  test "sum_json_numbers_pt2 - ignore it all" do
    assert sum_json_numbers_pt2(~s({"d":"red","e":[1,2,3,4],"f":5})) == 0
  end

  test "sum_json_numbers_pt2 - ignore just the map with red" do
    assert sum_json_numbers_pt2(~s([1,{"c":"red","b":2},3])) == 4
  end
end
