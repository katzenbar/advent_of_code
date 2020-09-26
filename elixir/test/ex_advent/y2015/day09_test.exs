defmodule ExAdvent.Y2015.Day09Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day09

  def example_input do
    [
      "London to Dublin = 464",
      "London to Belfast = 518",
      "Dublin to Belfast = 141"
    ]
  end

  test "build_combinations - 1" do
    set = MapSet.new([1])

    assert build_combinations(set) == [[1]]
  end

  test "build_combinations - 1,2" do
    set = MapSet.new([1, 2])

    assert build_combinations(set) == [[1, 2], [2, 1]]
  end

  test "build_combinations - 1,2,3" do
    set = MapSet.new([1, 2, 3])

    assert build_combinations(set) == [
             [1, 2, 3],
             [1, 3, 2],
             [2, 1, 3],
             [2, 3, 1],
             [3, 1, 2],
             [3, 2, 1]
           ]
  end

  test "collect_city_info" do
    assert collect_city_info(example_input()) == {
             MapSet.new(["London", "Dublin", "Belfast"]),
             %{
               "Belfast,Dublin" => 141,
               "Belfast,London" => 518,
               "Dublin,Belfast" => 141,
               "Dublin,London" => 464,
               "London,Belfast" => 518,
               "London,Dublin" => 464
             }
           }
  end

  test "calculate_route_distance" do
    distances = %{
      "Belfast,Dublin" => 141,
      "Belfast,London" => 518,
      "Dublin,Belfast" => 141,
      "Dublin,London" => 464,
      "London,Belfast" => 518,
      "London,Dublin" => 464
    }

    route = ["London", "Dublin", "Belfast"]

    assert calculate_route_distance(route, distances) == 605
  end

  test "find_route_distances" do
    assert Enum.min(find_route_distances(example_input())) == 605
  end
end
