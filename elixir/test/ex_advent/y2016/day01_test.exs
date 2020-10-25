defmodule ExAdvent.Y2016.Day01Test do
  use ExUnit.Case

  import ExAdvent.Y2016.Day01

  test "parse input" do
    input = "L2, R3"
    assert parse_input(input) == ["L2", "R3"]
  end

  test "turn - L when 0" do
    assert turn({0, 3, 5}, "L") == {270, 3, 5}
  end

  test "turn - L when 90" do
    assert turn({90, 3, 5}, "L") == {0, 3, 5}
  end

  test "turn - R when 0" do
    assert turn({0, 3, 5}, "R") == {90, 3, 5}
  end

  test "turn - R when 270" do
    assert turn({270, 3, 5}, "R") == {0, 3, 5}
  end

  test "walk - 0" do
    assert walk({0, 0, 0}, 4) == {0, 0, 4}
  end

  test "walk - 90" do
    assert walk({90, 0, 0}, 5) == {90, 5, 0}
  end

  test "walk - 180" do
    assert walk({180, 0, 0}, 4) == {180, 0, -4}
  end

  test "walk - 270" do
    assert walk({270, 0, 0}, 4) == {270, -4, 0}
  end

  test "execute_instructions - R2, L3" do
    assert execute_instructions_pt1(["R2", "L3"]) == {0, 2, 3}
  end

  test "distance_to_point - {0, 2, 3}" do
    assert distance_to_point({0, 2, 3}) == 5
  end

  test "distance_to_point - {0, -2, 3}" do
    assert distance_to_point({0, -2, 3}) == 5
  end

  test "execute_instructions_pt2" do
    assert execute_instructions_pt2(["R8", "R4", "R4", "R8"]) == {4, 0}
  end
end
