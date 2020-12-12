defmodule ExAdvent.Y2020.Day12Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day12

  test "parse input" do
    input = ~s"""
    F10
    N3
    F7
    R90
    F11
    """

    assert parse_input(input) == [{"F", 10}, {"N", 3}, {"F", 7}, {"R", 90}, {"F", 11}]
  end

  test "follow_instruction - N" do
    assert follow_instruction({"N", 3}, %{x: 2, y: 7, heading: 123}) == %{
             x: 2,
             y: 10,
             heading: 123
           }
  end

  test "follow_instruction - S" do
    assert follow_instruction({"S", 3}, %{x: 2, y: 7, heading: 123}) == %{
             x: 2,
             y: 4,
             heading: 123
           }
  end

  test "follow_instruction - E" do
    assert follow_instruction({"E", 3}, %{x: 2, y: 7, heading: 123}) == %{
             x: 5,
             y: 7,
             heading: 123
           }
  end

  test "follow_instruction - W" do
    assert follow_instruction({"W", 3}, %{x: 2, y: 7, heading: 123}) == %{
             x: -1,
             y: 7,
             heading: 123
           }
  end

  test "follow_instruction - L" do
    assert follow_instruction({"L", 32}, %{x: 2, y: 7, heading: 123}) == %{
             x: 2,
             y: 7,
             heading: 155
           }
  end

  test "follow_instruction - L, going over 360" do
    assert follow_instruction({"L", 57}, %{x: 2, y: 7, heading: 324}) == %{
             x: 2,
             y: 7,
             heading: 21
           }
  end

  test "follow_instruction - R" do
    assert follow_instruction({"R", 32}, %{x: 2, y: 7, heading: 123}) == %{
             x: 2,
             y: 7,
             heading: 91
           }
  end

  test "follow_instruction - R, going under 0" do
    assert follow_instruction({"R", 57}, %{x: 2, y: 7, heading: 12}) == %{
             x: 2,
             y: 7,
             heading: 315
           }
  end

  test "follow_instruction - F, heading 0" do
    assert follow_instruction({"F", 7}, %{x: 2, y: 7, heading: 0}) == %{
             x: 9,
             y: 7,
             heading: 0
           }
  end

  test "follow_instruction - F, heading 90" do
    assert follow_instruction({"F", 7}, %{x: 2, y: 7, heading: 90}) == %{
             x: 2,
             y: 14,
             heading: 90
           }
  end

  test "follow_instruction - F, heading 180" do
    assert follow_instruction({"F", 7}, %{x: 2, y: 7, heading: 180}) == %{
             x: -5,
             y: 7,
             heading: 180
           }
  end

  test "follow_instruction - F, heading 270" do
    assert follow_instruction({"F", 7}, %{x: 2, y: 7, heading: 270}) == %{
             x: 2,
             y: 0,
             heading: 270
           }
  end

  test "follow_navigation_instructions" do
    instructions = [{"F", 10}, {"N", 3}, {"F", 7}, {"R", 90}, {"F", 11}]

    assert follow_navigation_instructions(instructions) == %{x: 17, y: -8, heading: 270}
  end

  test "get_manhattan_distance_for_ship" do
    assert get_manhattan_distance_for_ship(%{x: 17, y: -8, heading: 270}) == 25
  end

  test "follow_instruction_with_waypoint - N" do
    coords = %{x: 2, y: 3, way_x: 4, way_y: 5}
    expected = %{x: 2, y: 3, way_x: 4, way_y: 8}

    assert follow_instruction_with_waypoint({"N", 3}, coords) == expected
  end

  test "follow_instruction_with_waypoint - S" do
    coords = %{x: 2, y: 3, way_x: 4, way_y: 5}
    expected = %{x: 2, y: 3, way_x: 4, way_y: 2}

    assert follow_instruction_with_waypoint({"S", 3}, coords) == expected
  end

  test "follow_instruction_with_waypoint - E" do
    coords = %{x: 2, y: 3, way_x: 4, way_y: 5}
    expected = %{x: 2, y: 3, way_x: 7, way_y: 5}

    assert follow_instruction_with_waypoint({"E", 3}, coords) == expected
  end

  test "follow_instruction_with_waypoint - W" do
    coords = %{x: 2, y: 3, way_x: 4, way_y: 5}
    expected = %{x: 2, y: 3, way_x: 1, way_y: 5}

    assert follow_instruction_with_waypoint({"W", 3}, coords) == expected
  end

  test "follow_instruction_with_waypoint - L 90" do
    coords = %{x: 2, y: 3, way_x: 4, way_y: 5}
    expected = %{x: 2, y: 3, way_x: -5, way_y: 4}

    assert follow_instruction_with_waypoint({"L", 90}, coords) == expected
  end

  test "follow_instruction_with_waypoint - L 180" do
    coords = %{x: 2, y: 3, way_x: 4, way_y: 5}
    expected = %{x: 2, y: 3, way_x: -4, way_y: -5}

    assert follow_instruction_with_waypoint({"L", 180}, coords) == expected
  end

  test "follow_instruction_with_waypoint - L 270" do
    coords = %{x: 2, y: 3, way_x: 4, way_y: 5}
    expected = %{x: 2, y: 3, way_x: 5, way_y: -4}

    assert follow_instruction_with_waypoint({"L", 270}, coords) == expected
  end

  test "follow_instruction_with_waypoint - R 90" do
    coords = %{x: 2, y: 3, way_x: 4, way_y: 5}
    expected = %{x: 2, y: 3, way_x: 5, way_y: -4}

    assert follow_instruction_with_waypoint({"R", 90}, coords) == expected
  end

  test "follow_instruction_with_waypoint - R 180" do
    coords = %{x: 2, y: 3, way_x: 4, way_y: 5}
    expected = %{x: 2, y: 3, way_x: -4, way_y: -5}

    assert follow_instruction_with_waypoint({"R", 180}, coords) == expected
  end

  test "follow_instruction_with_waypoint - R 270" do
    coords = %{x: 2, y: 3, way_x: 4, way_y: 5}
    expected = %{x: 2, y: 3, way_x: -5, way_y: 4}

    assert follow_instruction_with_waypoint({"R", 270}, coords) == expected
  end

  test "follow_instruction_with_waypoint - F" do
    coords = %{x: 2, y: 3, way_x: 4, way_y: 5}
    expected = %{x: 14, y: 18, way_x: 4, way_y: 5}

    assert follow_instruction_with_waypoint({"F", 3}, coords) == expected
  end

  test "follow_instructions_with_waypoint" do
    instructions = [{"F", 10}, {"N", 3}, {"F", 7}, {"R", 90}, {"F", 11}]

    assert follow_instructions_with_waypoint(instructions) == %{
             x: 214,
             y: -72,
             way_x: 4,
             way_y: -10
           }
  end
end
