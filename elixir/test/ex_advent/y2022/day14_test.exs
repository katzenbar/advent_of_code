defmodule ExAdvent.Y2022.Day14Test do
  use ExUnit.Case

  import ExAdvent.Y2022.Day14

  def sample_input() do
    ~s"""
    498,4 -> 498,6 -> 496,6
    503,4 -> 502,4 -> 502,9 -> 494,9
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() == {
             %{
               {494, 9} => :rock,
               {495, 9} => :rock,
               {496, 6} => :rock,
               {496, 9} => :rock,
               {497, 6} => :rock,
               {497, 9} => :rock,
               {498, 4} => :rock,
               {498, 5} => :rock,
               {498, 6} => :rock,
               {498, 9} => :rock,
               {499, 9} => :rock,
               {500, 9} => :rock,
               {501, 9} => :rock,
               {502, 4} => :rock,
               {502, 5} => :rock,
               {502, 6} => :rock,
               {502, 7} => :rock,
               {502, 8} => :rock,
               {502, 9} => :rock,
               {503, 4} => :rock
             },
             %{"max_x" => 503, "max_y" => 9, "min_x" => 494, "min_y" => 4}
           }
  end

  test "print_map" do
    {map, bb} = parsed_sample_input()

    assert print_map(map, bb) == ~s"""
           ..........
           ..........
           ..........
           ..........
           ....#...##
           ....#...#.
           ..###...#.
           ........#.
           ........#.
           #########.
           """
  end

  test "drop_sand" do
    {map, _} = parsed_sample_input()

    assert drop_sand(map, 11, 9) ==
             {:cont,
              %{
                {494, 9} => :rock,
                {495, 9} => :rock,
                {496, 6} => :rock,
                {496, 9} => :rock,
                {497, 6} => :rock,
                {497, 9} => :rock,
                {498, 4} => :rock,
                {498, 5} => :rock,
                {498, 6} => :rock,
                {498, 9} => :rock,
                {499, 9} => :rock,
                {500, 8} => :sand,
                {500, 9} => :rock,
                {501, 9} => :rock,
                {502, 4} => :rock,
                {502, 5} => :rock,
                {502, 6} => :rock,
                {502, 7} => :rock,
                {502, 8} => :rock,
                {502, 9} => :rock,
                {503, 4} => :rock
              }}
  end

  test "find_num_sands_to_abyss" do
    assert find_num_sands_to_abyss(parsed_sample_input()) == 24
  end

  test "find_safe_floor_spot" do
    assert find_safe_floor_spot(parsed_sample_input()) == 93
  end
end
