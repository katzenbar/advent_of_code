defmodule ExAdvent.Y2022.Day12Test do
  use ExUnit.Case

  import ExAdvent.Y2022.Day12

  def sample_input() do
    ~s"""
    Sabqponm
    abcryxxl
    accszExk
    acctuvwj
    abdefghi
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() == %{
             {0, 0} => 0,
             {0, 1} => 0,
             {0, 2} => 0,
             {0, 3} => 0,
             {0, 4} => 0,
             {1, 0} => 0,
             {1, 1} => 1,
             {1, 2} => 2,
             {1, 3} => 2,
             {1, 4} => 1,
             {2, 0} => 1,
             {2, 1} => 2,
             {2, 2} => 2,
             {2, 3} => 2,
             {2, 4} => 3,
             {3, 0} => 16,
             {3, 1} => 17,
             {3, 2} => 18,
             {3, 3} => 19,
             {3, 4} => 4,
             {4, 0} => 15,
             {4, 1} => 24,
             {4, 2} => 25,
             {4, 3} => 20,
             {4, 4} => 5,
             {5, 0} => 14,
             {5, 1} => 23,
             {5, 2} => 25,
             {5, 3} => 21,
             {5, 4} => 6,
             {6, 0} => 13,
             {6, 1} => 23,
             {6, 2} => 23,
             {6, 3} => 22,
             {6, 4} => 7,
             {7, 0} => 12,
             {7, 1} => 11,
             {7, 2} => 10,
             {7, 3} => 9,
             {7, 4} => 8,
             :start => {0, 0},
             :end => {5, 2}
           }
  end

  test "find_fewest_steps_start_to_end" do
    assert find_fewest_steps_start_to_end(parsed_sample_input()) == 31
  end

  test "find_fewest_steps_end_trail" do
    assert find_fewest_steps_end_trail(parsed_sample_input()) == 29
  end
end
