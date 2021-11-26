defmodule ExAdvent.Y2018.Day03Test do
  use ExUnit.Case

  import ExAdvent.Y2018.Day03

  test "parse input" do
    input = ~s"""
    #1 @ 1,3: 4x4
    #2 @ 3,1: 4x4
    #3 @ 5,5: 2x2
    """

    assert parse_input(input) == [
             {1, 1, 3, 4, 4},
             {2, 3, 1, 4, 4},
             {3, 5, 5, 2, 2}
           ]
  end

  test "add_claim_to_map - #3 @ 5,5: 2x2" do
    claim = {3, 5, 5, 2, 2}
    map = %{}

    result = add_claim_to_map(claim, map)

    expected = %{
      "5,5" => MapSet.new([3]),
      "5,6" => MapSet.new([3]),
      "6,5" => MapSet.new([3]),
      "6,6" => MapSet.new([3])
    }

    assert result == expected
  end

  test "mark_claims_on_map" do
    claims = [
      {1, 1, 3, 4, 4},
      {2, 3, 1, 4, 4},
      {3, 5, 5, 2, 2}
    ]

    assert mark_claims_on_map(claims) == %{
             "1,3" => MapSet.new([1]),
             "1,4" => MapSet.new([1]),
             "1,5" => MapSet.new([1]),
             "1,6" => MapSet.new([1]),
             "2,3" => MapSet.new([1]),
             "2,4" => MapSet.new([1]),
             "2,5" => MapSet.new([1]),
             "2,6" => MapSet.new([1]),
             "3,1" => MapSet.new([2]),
             "3,2" => MapSet.new([2]),
             "3,3" => MapSet.new([1, 2]),
             "3,4" => MapSet.new([1, 2]),
             "3,5" => MapSet.new([1]),
             "3,6" => MapSet.new([1]),
             "4,1" => MapSet.new([2]),
             "4,2" => MapSet.new([2]),
             "4,3" => MapSet.new([1, 2]),
             "4,4" => MapSet.new([1, 2]),
             "4,5" => MapSet.new([1]),
             "4,6" => MapSet.new([1]),
             "5,1" => MapSet.new([2]),
             "5,2" => MapSet.new([2]),
             "5,3" => MapSet.new([2]),
             "5,4" => MapSet.new([2]),
             "5,5" => MapSet.new([3]),
             "5,6" => MapSet.new([3]),
             "6,1" => MapSet.new([2]),
             "6,2" => MapSet.new([2]),
             "6,3" => MapSet.new([2]),
             "6,4" => MapSet.new([2]),
             "6,5" => MapSet.new([3]),
             "6,6" => MapSet.new([3])
           }
  end

  test "number_of_cells_with_multiple_claims" do
    claims = [
      {1, 1, 3, 4, 4},
      {2, 3, 1, 4, 4},
      {3, 5, 5, 2, 2}
    ]

    assert number_of_cells_with_multiple_claims(claims) == 4
  end

  test "find_non_overlapping_claim" do
    claims = [
      {1, 1, 3, 4, 4},
      {2, 3, 1, 4, 4},
      {3, 5, 5, 2, 2}
    ]

    assert find_non_overlapping_claim(claims) == 3
  end
end
