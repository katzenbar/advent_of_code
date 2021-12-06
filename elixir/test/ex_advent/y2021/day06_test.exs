defmodule ExAdvent.Y2021.Day06Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day06

  test "parse input" do
    input = "3,4,3,1,2"

    assert parse_input(input) == %{
             1 => 1,
             2 => 1,
             3 => 2,
             4 => 1
           }
  end

  test "simulate_next_day" do
    fish_map = %{
      1 => 1,
      2 => 1,
      3 => 2,
      4 => 1
    }

    assert simulate_next_day(fish_map) == %{
             0 => 1,
             1 => 1,
             2 => 2,
             3 => 1
           }
  end

  test "simulate_num_days, 9" do
    fish_map = %{
      1 => 1,
      2 => 1,
      3 => 2,
      4 => 1
    }

    assert simulate_num_days(fish_map, 9) == %{
             0 => 1,
             1 => 3,
             2 => 2,
             3 => 2,
             4 => 1,
             6 => 1,
             8 => 1
           }
  end

  test "simulate_num_days, 18" do
    fish_map = %{
      1 => 1,
      2 => 1,
      3 => 2,
      4 => 1
    }

    assert simulate_num_days(fish_map, 18) == %{
             0 => 3,
             1 => 5,
             2 => 3,
             3 => 2,
             4 => 2,
             5 => 1,
             6 => 5,
             7 => 1,
             8 => 4
           }
  end

  test "fish_after_num_days - 18" do
    fish_map = %{
      1 => 1,
      2 => 1,
      3 => 2,
      4 => 1
    }

    assert fish_after_num_days(fish_map, 18) == 26
  end

  test "fish_after_num_days - 80" do
    fish_map = %{
      1 => 1,
      2 => 1,
      3 => 2,
      4 => 1
    }

    assert fish_after_num_days(fish_map, 80) == 5934
  end

  test "fish_after_num_days - 256" do
    fish_map = %{
      1 => 1,
      2 => 1,
      3 => 2,
      4 => 1
    }

    assert fish_after_num_days(fish_map, 256) == 26_984_457_539
  end
end
