defmodule ExAdvent.Y2015.Day06Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day06

  test "parse_instruction - turn on 0,0 through 999,999" do
    assert parse_instruction("turn on 0,0 through 999,999") == {:on, 0, 0, 999, 999}
  end

  test "parse_instruction - toggle 0,0 through 999,0" do
    assert parse_instruction("toggle 0,0 through 999,0") == {:toggle, 0, 0, 999, 0}
  end

  test "parse_instruction - turn off 499,499 through 500,500" do
    assert parse_instruction("turn off 499,499 through 500,500") == {:off, 499, 499, 500, 500}
  end

  test "execute_instruction - turn on 0,1 through 0,2" do
    grid = %{}
    result = %{"0,1" => 1, "0,2" => 1}

    assert execute_instruction("turn on 0,1 through 0,2", grid, &next_value_pt1/2) == result
  end

  test "execute_instruction - turn on 0,0 through 0,2" do
    grid = %{"0,0" => 1, "0,1" => 1, "0,2" => 1, "1,1" => 1}
    result = %{"0,0" => 0, "0,1" => 0, "0,2" => 0, "1,1" => 1}

    assert execute_instruction("turn off 0,0 through 0,2", grid, &next_value_pt1/2) == result
  end

  test "execute_instruction - toggle 2,1 through 2,2" do
    grid = %{"2,1" => 0, "2,2" => 1}
    result = %{"2,1" => 1, "2,2" => 0}

    assert execute_instruction("toggle 2,1 through 2,2", grid, &next_value_pt1/2) == result
  end

  test "next_value_pt1 - on when nil" do
    assert next_value_pt1(:on, nil) == {nil, 1}
  end

  test "next_value_pt1 - on when 0" do
    assert next_value_pt1(:on, 0) == {0, 1}
  end

  test "next_value_pt1 - on when 1" do
    assert next_value_pt1(:on, 1) == {1, 1}
  end

  test "next_value_pt1 - off when nil" do
    assert next_value_pt1(:off, nil) == {nil, 0}
  end

  test "next_value_pt1 - off when 0" do
    assert next_value_pt1(:off, 0) == {0, 0}
  end

  test "next_value_pt1 - off when 1" do
    assert next_value_pt1(:off, 1) == {1, 0}
  end

  test "next_value_pt1 - toggle when nil" do
    assert next_value_pt1(:toggle, nil) == {nil, 1}
  end

  test "next_value_pt1 - toggle when 0" do
    assert next_value_pt1(:toggle, 0) == {0, 1}
  end

  test "next_value_pt1 - toggle when 1" do
    assert next_value_pt1(:toggle, 1) == {1, 0}
  end

  test "next_value_pt2 - on when nil" do
    assert next_value_pt2(:on, nil) == {nil, 1}
  end

  test "next_value_pt2 - on when 0" do
    assert next_value_pt2(:on, 0) == {0, 1}
  end

  test "next_value_pt2 - on when 2" do
    assert next_value_pt2(:on, 2) == {2, 3}
  end

  test "next_value_pt2 - off when nil" do
    assert next_value_pt2(:off, nil) == {nil, 0}
  end

  test "next_value_pt2 - off when 0" do
    assert next_value_pt2(:off, 0) == {0, 0}
  end

  test "next_value_pt2 - off when 2" do
    assert next_value_pt2(:off, 2) == {2, 1}
  end

  test "next_value_pt2 - toggle when nil" do
    assert next_value_pt2(:toggle, nil) == {nil, 2}
  end

  test "next_value_pt2 - toggle when 0" do
    assert next_value_pt2(:toggle, 0) == {0, 2}
  end

  test "next_value_pt2 - toggle when 3" do
    assert next_value_pt2(:toggle, 3) == {3, 5}
  end
end
