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

  test "execute_instruction - turn on 0,0 through 2,2" do
    grid = MapSet.new()
    result = MapSet.new(["0,0", "1,0", "2,0", "0,1", "1,1", "2,1", "0,2", "1,2", "2,2"])

    assert execute_instruction({:on, 0, 0, 2, 2}, grid) == result
  end

  test "execute_instruction - turn off 1,1 through 2,2" do
    grid = MapSet.new(["0,0", "1,0", "2,0", "0,1", "1,1", "2,1", "0,2", "1,2", "2,2"])
    result = MapSet.new(["0,0", "1,0", "2,0", "0,1", "0,2"])

    assert execute_instruction({:off, 1, 1, 2, 2}, grid) == result
  end

  test "execute_instruction - toggle 2,1 through 2,2" do
    grid = MapSet.new(["0,0", "1,0", "2,0", "0,1", "1,1", "0,2", "1,2", "2,2"])
    result = MapSet.new(["0,0", "1,0", "2,0", "0,1", "1,1", "2,1", "0,2", "1,2"])

    assert execute_instruction({:toggle, 2, 1, 2, 2}, grid) == result
  end

  test "execute instruction pt2 - turn on 0,0 through 0,0 when not set" do
    grid = %{}
    result = %{"0,0" => 1}

    assert execute_instruction_pt2("turn on 0,0 through 0,0", grid) == result
  end

  test "execute instruction pt2 - turn on 0,0 through 0,0 when already set" do
    grid = %{"0,0" => 2}
    result = %{"0,0" => 3}

    assert execute_instruction_pt2("turn on 0,0 through 0,0", grid) == result
  end

  test "execute instruction pt2 - turn off 0,0 through 0,0 when not set" do
    grid = %{}
    result = %{"0,0" => 0}

    assert execute_instruction_pt2("turn off 0,0 through 0,0", grid) == result
  end

  test "execute instruction pt2 - turn off 0,0 through 0,0 when already set to 0" do
    grid = %{"0,0" => 0}
    result = %{"0,0" => 0}

    assert execute_instruction_pt2("turn off 0,0 through 0,0", grid) == result
  end

  test "execute instruction pt2 - turn off 0,0 through 0,0 when already set to 2" do
    grid = %{"0,0" => 2}
    result = %{"0,0" => 1}

    assert execute_instruction_pt2("turn off 0,0 through 0,0", grid) == result
  end

  test "execute instruction pt2 - toggle 0,0 through 0,0 when not set" do
    grid = %{}
    result = %{"0,0" => 2}

    assert execute_instruction_pt2("toggle 0,0 through 0,0", grid) == result
  end

  test "execute instruction pt2 - toggle 0,0 through 0,0 when already set" do
    grid = %{"0,0" => 2}
    result = %{"0,0" => 4}

    assert execute_instruction_pt2("toggle 0,0 through 0,0", grid) == result
  end
end
