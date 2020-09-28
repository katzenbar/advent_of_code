defmodule ExAdvent.Y2015.Day18Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day18

  test "parse_input" do
    input = [".#.#.#", "...##.", "#....#", "..#...", "#.#..#", "####.."]

    # .#.#.#
    # ...##.
    # #....#
    # ..#...
    # #.#..#
    # ####..
    assert parse_input(input) == %{
             {0, 0} => 0,
             {0, 1} => 1,
             {0, 2} => 0,
             {0, 3} => 1,
             {0, 4} => 0,
             {0, 5} => 1,
             {1, 0} => 0,
             {1, 1} => 0,
             {1, 2} => 0,
             {1, 3} => 1,
             {1, 4} => 1,
             {1, 5} => 0,
             {2, 0} => 1,
             {2, 1} => 0,
             {2, 2} => 0,
             {2, 3} => 0,
             {2, 4} => 0,
             {2, 5} => 1,
             {3, 0} => 0,
             {3, 1} => 0,
             {3, 2} => 1,
             {3, 3} => 0,
             {3, 4} => 0,
             {3, 5} => 0,
             {4, 0} => 1,
             {4, 1} => 0,
             {4, 2} => 1,
             {4, 3} => 0,
             {4, 4} => 0,
             {4, 5} => 1,
             {5, 0} => 1,
             {5, 1} => 1,
             {5, 2} => 1,
             {5, 3} => 1,
             {5, 4} => 0,
             {5, 5} => 0
           }
  end

  test "get_next_light_state - was on with 0 neighbors on" do
    grid = %{
      {0, 0} => 0,
      {0, 1} => 0,
      {1, 0} => 0,
      {1, 1} => 1
    }

    assert get_next_light_state({1, 1}, grid) == 0
  end

  test "get_next_light_state - was on with 1 neighbor on" do
    grid = %{
      {0, 0} => 0,
      {0, 1} => 0,
      {1, 0} => 1,
      {1, 1} => 1
    }

    assert get_next_light_state({1, 1}, grid) == 0
  end

  test "get_next_light_state - was on with 2 neighbors on" do
    grid = %{
      {0, 0} => 0,
      {0, 1} => 1,
      {1, 0} => 1,
      {1, 1} => 1
    }

    assert get_next_light_state({1, 1}, grid) == 1
  end

  test "get_next_light_state - was on with 3 neighbors on" do
    grid = %{
      {0, 0} => 0,
      {0, 1} => 1,
      {0, 2} => 1,
      {1, 0} => 1,
      {1, 1} => 1,
      {1, 2} => 0
    }

    assert get_next_light_state({1, 1}, grid) == 1
  end

  test "get_next_light_state - was on with 4 neighbors on" do
    grid = %{
      {0, 0} => 0,
      {0, 1} => 1,
      {0, 2} => 1,
      {1, 0} => 1,
      {1, 1} => 1,
      {1, 2} => 1
    }

    assert get_next_light_state({1, 1}, grid) == 0
  end

  test "get_next_light_state - was off with 0 neighbors on" do
    grid = %{
      {0, 0} => 0,
      {0, 1} => 0,
      {1, 0} => 0,
      {1, 1} => 0
    }

    assert get_next_light_state({1, 1}, grid) == 0
  end

  test "get_next_light_state - was off with 1 neighbor on" do
    grid = %{
      {0, 0} => 0,
      {0, 1} => 0,
      {1, 0} => 1,
      {1, 1} => 0
    }

    assert get_next_light_state({1, 1}, grid) == 0
  end

  test "get_next_light_state - was off with 2 neighbors on" do
    grid = %{
      {0, 0} => 0,
      {0, 1} => 1,
      {1, 0} => 1,
      {1, 1} => 0
    }

    assert get_next_light_state({1, 1}, grid) == 0
  end

  test "get_next_light_state - was off with 3 neighbors on" do
    grid = %{
      {0, 0} => 0,
      {0, 1} => 1,
      {0, 2} => 1,
      {1, 0} => 1,
      {1, 1} => 0,
      {1, 2} => 0
    }

    assert get_next_light_state({1, 1}, grid) == 1
  end

  test "get_next_grid" do
    next_grid =
      [".#.#.#", "...##.", "#....#", "..#...", "#.#..#", "####.."]
      |> parse_input()
      |> get_next_grid()

    # ..##..
    # ..##.#
    # ...##.
    # ......
    # #.....
    # #.##..
    assert next_grid == %{
             {0, 0} => 0,
             {0, 1} => 0,
             {0, 2} => 1,
             {0, 3} => 1,
             {0, 4} => 0,
             {0, 5} => 0,
             {1, 0} => 0,
             {1, 1} => 0,
             {1, 2} => 1,
             {1, 3} => 1,
             {1, 4} => 0,
             {1, 5} => 1,
             {2, 0} => 0,
             {2, 1} => 0,
             {2, 2} => 0,
             {2, 3} => 1,
             {2, 4} => 1,
             {2, 5} => 0,
             {3, 0} => 0,
             {3, 1} => 0,
             {3, 2} => 0,
             {3, 3} => 0,
             {3, 4} => 0,
             {3, 5} => 0,
             {4, 0} => 1,
             {4, 1} => 0,
             {4, 2} => 0,
             {4, 3} => 0,
             {4, 4} => 0,
             {4, 5} => 0,
             {5, 0} => 1,
             {5, 1} => 0,
             {5, 2} => 1,
             {5, 3} => 1,
             {5, 4} => 0,
             {5, 5} => 0
           }
  end
end
