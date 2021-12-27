defmodule ExAdvent.Y2021.Day23Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day23

  test "parse input" do
    input = ~s"""
    #############
    #...........#
    ###B#C#B#D###
      #A#D#C#A#
      #########
    """

    assert parse_input(input) == %{
             {:room, "A", 1} => "A",
             {:room, "A", 2} => "B",
             {:room, "B", 1} => "D",
             {:room, "B", 2} => "C",
             {:room, "C", 1} => "C",
             {:room, "C", 2} => "B",
             {:room, "D", 1} => "A",
             {:room, "D", 2} => "D"
           }
  end

  test "calculate_possible_moves_for_spaces - room depth 2 -- starting from room" do
    {_, possible_moves_for_spaces} = calculate_possible_moves_for_spaces(2)

    assert Map.get(possible_moves_for_spaces, {:hall, nil, 1}) == [
             [
               {:hall, nil, 2},
               {:hall, nil, 3},
               {:hall, nil, 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:hall, nil, 8},
               {:hall, nil, 9},
               {:room, "D", 2}
             ],
             [
               {:hall, nil, 2},
               {:hall, nil, 3},
               {:hall, nil, 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:hall, nil, 8},
               {:hall, nil, 9},
               {:room, "D", 2},
               {:room, "D", 1}
             ],
             [
               {:hall, nil, 2},
               {:hall, nil, 3},
               {:hall, nil, 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:room, "C", 2}
             ],
             [
               {:hall, nil, 2},
               {:hall, nil, 3},
               {:hall, nil, 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:room, "C", 2},
               {:room, "C", 1}
             ],
             [{:hall, nil, 2}, {:hall, nil, 3}, {:hall, nil, 4}, {:hall, nil, 5}, {:room, "B", 2}],
             [{:hall, nil, 2}, {:hall, nil, 3}, {:hall, nil, 4}, {:hall, nil, 5}, {:room, "B", 2}, {:room, "B", 1}],
             [{:hall, nil, 2}, {:hall, nil, 3}, {:room, "A", 2}],
             [{:hall, nil, 2}, {:hall, nil, 3}, {:room, "A", 2}, {:room, "A", 1}]
           ]
  end

  test "calculate_possible_moves_for_spaces - room depth 2 -- starting from hall" do
    {_, possible_moves_for_spaces} = calculate_possible_moves_for_spaces(2)

    assert Map.get(possible_moves_for_spaces, {:hall, nil, 1}) == [
             [
               {:hall, nil, 2},
               {:hall, nil, 3},
               {:hall, nil, 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:hall, nil, 8},
               {:hall, nil, 9},
               {:room, "D", 2}
             ],
             [
               {:hall, nil, 2},
               {:hall, nil, 3},
               {:hall, nil, 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:hall, nil, 8},
               {:hall, nil, 9},
               {:room, "D", 2},
               {:room, "D", 1}
             ],
             [
               {:hall, nil, 2},
               {:hall, nil, 3},
               {:hall, nil, 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:room, "C", 2}
             ],
             [
               {:hall, nil, 2},
               {:hall, nil, 3},
               {:hall, nil, 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:room, "C", 2},
               {:room, "C", 1}
             ],
             [{:hall, nil, 2}, {:hall, nil, 3}, {:hall, nil, 4}, {:hall, nil, 5}, {:room, "B", 2}],
             [{:hall, nil, 2}, {:hall, nil, 3}, {:hall, nil, 4}, {:hall, nil, 5}, {:room, "B", 2}, {:room, "B", 1}],
             [{:hall, nil, 2}, {:hall, nil, 3}, {:room, "A", 2}],
             [{:hall, nil, 2}, {:hall, nil, 3}, {:room, "A", 2}, {:room, "A", 1}]
           ]
  end

  test "calculate_possible_moves_for_spaces - room depth 4 -- starting from room" do
    {_, possible_moves_for_spaces} = calculate_possible_moves_for_spaces(4)

    assert Map.get(possible_moves_for_spaces, {:room, "B", 2}) == [
             [{:room, "B", 3}, {:room, "B", 4}, {:hall, nil, 5}, {:hall, nil, 4}],
             [{:room, "B", 3}, {:room, "B", 4}, {:hall, nil, 5}, {:hall, nil, 4}, {:hall, nil, 3}, {:hall, nil, 2}],
             [
               {:room, "B", 3},
               {:room, "B", 4},
               {:hall, nil, 5},
               {:hall, nil, 4},
               {:hall, nil, 3},
               {:hall, nil, 2},
               {:hall, nil, 1}
             ],
             [{:room, "B", 3}, {:room, "B", 4}, {:hall, nil, 5}, {:hall, nil, 4}, {:hall, nil, 3}, {:room, "A", 4}],
             [
               {:room, "B", 3},
               {:room, "B", 4},
               {:hall, nil, 5},
               {:hall, nil, 4},
               {:hall, nil, 3},
               {:room, "A", 4},
               {:room, "A", 3}
             ],
             [
               {:room, "B", 3},
               {:room, "B", 4},
               {:hall, nil, 5},
               {:hall, nil, 4},
               {:hall, nil, 3},
               {:room, "A", 4},
               {:room, "A", 3},
               {:room, "A", 2}
             ],
             [
               {:room, "B", 3},
               {:room, "B", 4},
               {:hall, nil, 5},
               {:hall, nil, 4},
               {:hall, nil, 3},
               {:room, "A", 4},
               {:room, "A", 3},
               {:room, "A", 2},
               {:room, "A", 1}
             ],
             [{:room, "B", 3}, {:room, "B", 4}, {:hall, nil, 5}, {:hall, nil, 6}],
             [{:room, "B", 3}, {:room, "B", 4}, {:hall, nil, 5}, {:hall, nil, 6}, {:hall, nil, 7}, {:hall, nil, 8}],
             [
               {:room, "B", 3},
               {:room, "B", 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:hall, nil, 8},
               {:hall, nil, 9},
               {:hall, nil, 10}
             ],
             [
               {:room, "B", 3},
               {:room, "B", 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:hall, nil, 8},
               {:hall, nil, 9},
               {:hall, nil, 10},
               {:hall, nil, 11}
             ],
             [
               {:room, "B", 3},
               {:room, "B", 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:hall, nil, 8},
               {:hall, nil, 9},
               {:room, "D", 4}
             ],
             [
               {:room, "B", 3},
               {:room, "B", 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:hall, nil, 8},
               {:hall, nil, 9},
               {:room, "D", 4},
               {:room, "D", 3}
             ],
             [
               {:room, "B", 3},
               {:room, "B", 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:hall, nil, 8},
               {:hall, nil, 9},
               {:room, "D", 4},
               {:room, "D", 3},
               {:room, "D", 2}
             ],
             [
               {:room, "B", 3},
               {:room, "B", 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:hall, nil, 8},
               {:hall, nil, 9},
               {:room, "D", 4},
               {:room, "D", 3},
               {:room, "D", 2},
               {:room, "D", 1}
             ],
             [{:room, "B", 3}, {:room, "B", 4}, {:hall, nil, 5}, {:hall, nil, 6}, {:hall, nil, 7}, {:room, "C", 4}],
             [
               {:room, "B", 3},
               {:room, "B", 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:room, "C", 4},
               {:room, "C", 3}
             ],
             [
               {:room, "B", 3},
               {:room, "B", 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:room, "C", 4},
               {:room, "C", 3},
               {:room, "C", 2}
             ],
             [
               {:room, "B", 3},
               {:room, "B", 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:room, "C", 4},
               {:room, "C", 3},
               {:room, "C", 2},
               {:room, "C", 1}
             ]
           ]
  end

  test "calculate_possible_moves_for_spaces - room depth 4 -- starting from hall" do
    {_, possible_moves_for_spaces} = calculate_possible_moves_for_spaces(4)

    assert Map.get(possible_moves_for_spaces, {:hall, nil, 1}) == [
             [
               {:hall, nil, 2},
               {:hall, nil, 3},
               {:hall, nil, 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:hall, nil, 8},
               {:hall, nil, 9},
               {:room, "D", 4}
             ],
             [
               {:hall, nil, 2},
               {:hall, nil, 3},
               {:hall, nil, 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:hall, nil, 8},
               {:hall, nil, 9},
               {:room, "D", 4},
               {:room, "D", 3}
             ],
             [
               {:hall, nil, 2},
               {:hall, nil, 3},
               {:hall, nil, 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:hall, nil, 8},
               {:hall, nil, 9},
               {:room, "D", 4},
               {:room, "D", 3},
               {:room, "D", 2}
             ],
             [
               {:hall, nil, 2},
               {:hall, nil, 3},
               {:hall, nil, 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:hall, nil, 8},
               {:hall, nil, 9},
               {:room, "D", 4},
               {:room, "D", 3},
               {:room, "D", 2},
               {:room, "D", 1}
             ],
             [
               {:hall, nil, 2},
               {:hall, nil, 3},
               {:hall, nil, 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:room, "C", 4}
             ],
             [
               {:hall, nil, 2},
               {:hall, nil, 3},
               {:hall, nil, 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:room, "C", 4},
               {:room, "C", 3}
             ],
             [
               {:hall, nil, 2},
               {:hall, nil, 3},
               {:hall, nil, 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:room, "C", 4},
               {:room, "C", 3},
               {:room, "C", 2}
             ],
             [
               {:hall, nil, 2},
               {:hall, nil, 3},
               {:hall, nil, 4},
               {:hall, nil, 5},
               {:hall, nil, 6},
               {:hall, nil, 7},
               {:room, "C", 4},
               {:room, "C", 3},
               {:room, "C", 2},
               {:room, "C", 1}
             ],
             [{:hall, nil, 2}, {:hall, nil, 3}, {:hall, nil, 4}, {:hall, nil, 5}, {:room, "B", 4}],
             [{:hall, nil, 2}, {:hall, nil, 3}, {:hall, nil, 4}, {:hall, nil, 5}, {:room, "B", 4}, {:room, "B", 3}],
             [
               {:hall, nil, 2},
               {:hall, nil, 3},
               {:hall, nil, 4},
               {:hall, nil, 5},
               {:room, "B", 4},
               {:room, "B", 3},
               {:room, "B", 2}
             ],
             [
               {:hall, nil, 2},
               {:hall, nil, 3},
               {:hall, nil, 4},
               {:hall, nil, 5},
               {:room, "B", 4},
               {:room, "B", 3},
               {:room, "B", 2},
               {:room, "B", 1}
             ],
             [{:hall, nil, 2}, {:hall, nil, 3}, {:room, "A", 4}],
             [{:hall, nil, 2}, {:hall, nil, 3}, {:room, "A", 4}, {:room, "A", 3}],
             [{:hall, nil, 2}, {:hall, nil, 3}, {:room, "A", 4}, {:room, "A", 3}, {:room, "A", 2}],
             [{:hall, nil, 2}, {:hall, nil, 3}, {:room, "A", 4}, {:room, "A", 3}, {:room, "A", 2}, {:room, "A", 1}]
           ]
  end

  test "calculate_estimated_work_remaining -- initial" do
    positions = %{
      {:room, "A", 1} => "A",
      {:room, "A", 2} => "B",
      {:room, "B", 1} => "D",
      {:room, "B", 2} => "C",
      {:room, "C", 1} => "C",
      {:room, "C", 2} => "B",
      {:room, "D", 1} => "A",
      {:room, "D", 2} => "D"
    }

    possible_moves_for_spaces = calculate_possible_moves_for_spaces(2)

    assert calculate_estimated_work_remaining(positions, possible_moves_for_spaces) == 12499
  end

  test "calculate_estimated_work_remaining -- after one move" do
    positions = %{
      {:hall, nil, 4} => "B",
      {:room, "A", 1} => "A",
      {:room, "A", 2} => "B",
      {:room, "B", 1} => "D",
      {:room, "B", 2} => "C",
      {:room, "C", 1} => "C",
      {:room, "C", 2} => nil,
      {:room, "D", 1} => "A",
      {:room, "D", 2} => "D"
    }

    possible_moves_for_spaces = calculate_possible_moves_for_spaces(2)

    assert calculate_estimated_work_remaining(positions, possible_moves_for_spaces) == 12479
  end

  test "calculate_estimated_work_remaining -- after two moves" do
    positions = %{
      {:hall, nil, 4} => "B",
      {:room, "A", 1} => "A",
      {:room, "A", 2} => "B",
      {:room, "B", 1} => "D",
      {:room, "B", 2} => nil,
      {:room, "C", 1} => "C",
      {:room, "C", 2} => "C",
      {:room, "D", 1} => "A",
      {:room, "D", 2} => "D"
    }

    possible_moves_for_spaces = calculate_possible_moves_for_spaces(2)

    assert calculate_estimated_work_remaining(positions, possible_moves_for_spaces) == 12079
  end

  test "calculate_estimated_work_remaining -- after three moves" do
    positions = %{
      {:hall, nil, 4} => "B",
      {:room, "A", 1} => "A",
      {:room, "A", 2} => "B",
      {:room, "B", 1} => "D",
      {:room, "B", 2} => nil,
      {:room, "C", 1} => "C",
      {:room, "C", 2} => "C",
      {:room, "D", 1} => "A",
      {:room, "D", 2} => "D"
    }

    possible_moves_for_spaces = calculate_possible_moves_for_spaces(2)

    assert calculate_estimated_work_remaining(positions, possible_moves_for_spaces) == 12079
  end

  test "is_valid_move? -- moving to the hallway" do
    start_space = {:room, "C", 2}

    path = [
      {:hall, nil, 7},
      {:hall, nil, 6},
      {:hall, nil, 5},
      {:hall, nil, 4}
    ]

    positions = %{
      {:room, "A", 1} => "A",
      {:room, "A", 2} => "B",
      {:room, "B", 1} => "D",
      {:room, "B", 2} => "C",
      {:room, "C", 1} => "C",
      {:room, "C", 2} => "B",
      {:room, "D", 1} => "A",
      {:room, "D", 2} => "D"
    }

    assert is_valid_move?(start_space, path, positions) == true
  end

  test "is_valid_move? -- move to room" do
    start_space = {:room, "B", 2}

    path = [
      {:hall, nil, 5},
      {:hall, nil, 6},
      {:hall, nil, 7},
      {:room, "C", 2}
    ]

    positions = %{
      {:room, "A", 1} => "A",
      {:room, "A", 2} => "B",
      {:room, "B", 1} => "D",
      {:room, "B", 2} => "C",
      {:room, "C", 1} => "C",
      {:hall, nil, 4} => "B",
      {:room, "D", 1} => "A",
      {:room, "D", 2} => "D"
    }

    assert is_valid_move?(start_space, path, positions) == true
  end

  test "is_valid_move? -- B move to lower room" do
    start_space = {:hall, nil, 4}

    path = [
      {:hall, nil, 5},
      {:room, "B", 2},
      {:room, "B", 1}
    ]

    positions = %{
      {:hall, nil, 4} => "B",
      {:hall, nil, 6} => "D",
      {:room, "A", 1} => "A",
      {:room, "A", 2} => "B",
      {:room, "B", 1} => nil,
      {:room, "B", 2} => nil,
      {:room, "C", 1} => "C",
      {:room, "C", 2} => "C",
      {:room, "D", 1} => "A",
      {:room, "D", 2} => "D"
    }

    assert is_valid_move?(start_space, path, positions) == true
  end

  test "is_valid_move? -- B move to upper room" do
    start_space = {:room, "A", 2}

    path = [
      {:hall, nil, 3},
      {:hall, nil, 4},
      {:room, "B", 2}
    ]

    positions = %{
      {:hall, nil, 6} => "D",
      {:room, "A", 1} => "A",
      {:room, "A", 2} => "B",
      {:room, "B", 1} => "B",
      {:room, "B", 2} => nil,
      {:room, "C", 1} => "C",
      {:room, "C", 2} => "C",
      {:room, "D", 1} => "A",
      {:room, "D", 2} => "D"
    }

    assert is_valid_move?(start_space, path, positions) == true
  end

  test "is_valid_move? -- D move to right" do
    start_space = {:room, "D", 4}

    path = [
      {:hall, nil, 9},
      {:hall, nil, 10},
      {:hall, nil, 11}
    ]

    positions = %{
      {:room, "A", 1} => "A",
      {:room, "A", 2} => "D",
      {:room, "A", 3} => "D",
      {:room, "A", 4} => "B",
      {:room, "B", 1} => "D",
      {:room, "B", 2} => "B",
      {:room, "B", 3} => "C",
      {:room, "B", 4} => "C",
      {:room, "C", 1} => "C",
      {:room, "C", 2} => "A",
      {:room, "C", 3} => "B",
      {:room, "C", 4} => "B",
      {:room, "D", 1} => "A",
      {:room, "D", 2} => "C",
      {:room, "D", 3} => "A",
      {:room, "D", 4} => "D"
    }

    assert is_valid_move?(start_space, path, positions) == true
  end

  test "make_moves" do
    positions = %{
      {:room, "A", 1} => "A",
      {:room, "A", 2} => "B",
      {:room, "B", 1} => "D",
      {:room, "B", 2} => "C",
      {:room, "C", 1} => "C",
      {:room, "C", 2} => "B",
      {:room, "D", 1} => "A",
      {:room, "D", 2} => "D"
    }

    assert make_moves(positions) == 12521
  end

  test "make_moves -- extended edition for part 2" do
    positions =
      %{
        {:room, "A", 1} => "A",
        {:room, "A", 2} => "B",
        {:room, "B", 1} => "D",
        {:room, "B", 2} => "C",
        {:room, "C", 1} => "C",
        {:room, "C", 2} => "B",
        {:room, "D", 1} => "A",
        {:room, "D", 2} => "D"
      }
      |> add_amphipods_part_2()

    assert make_moves(positions, 4) == 44169
  end
end
