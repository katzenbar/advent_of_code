defmodule ExAdvent.Y2022.Day16Test do
  use ExUnit.Case

  import ExAdvent.Y2022.Day16

  def sample_input() do
    ~s"""
    Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
    Valve BB has flow rate=13; tunnels lead to valves CC, AA
    Valve CC has flow rate=2; tunnels lead to valves DD, BB
    Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
    Valve EE has flow rate=3; tunnels lead to valves FF, DD
    Valve FF has flow rate=0; tunnels lead to valves EE, GG
    Valve GG has flow rate=0; tunnels lead to valves FF, HH
    Valve HH has flow rate=22; tunnel leads to valve GG
    Valve II has flow rate=0; tunnels lead to valves AA, JJ
    Valve JJ has flow rate=21; tunnel leads to valve II
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() == %{
             "AA" => {0, ["DD", "II", "BB"]},
             "BB" => {13, ["CC", "AA"]},
             "CC" => {2, ["DD", "BB"]},
             "DD" => {20, ["CC", "AA", "EE"]},
             "EE" => {3, ["FF", "DD"]},
             "FF" => {0, ["EE", "GG"]},
             "GG" => {0, ["FF", "HH"]},
             "HH" => {22, ["GG"]},
             "II" => {0, ["AA", "JJ"]},
             "JJ" => {21, ["II"]}
           }
  end

  test "get_highest_pressure_to_release, one actor" do
    assert get_highest_pressure_to_release(parsed_sample_input(), [{"AA", 30}]) == 1651
  end

  test "get_highest_pressure_to_release, two actors" do
    assert get_highest_pressure_to_release(parsed_sample_input(), [{"AA", 26}, {"AA", 26}]) == 1707
  end
end
