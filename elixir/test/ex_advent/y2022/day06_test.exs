defmodule ExAdvent.Y2022.Day06Test do
  use ExUnit.Case

  import ExAdvent.Y2022.Day06

  def sample_input() do
    ~s"""
    mjqjpqmgbljsphdztnvjfqwrcgsmlb
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() == "mjqjpqmgbljsphdztnvjfqwrcgsmlb"
  end

  test "find_packet_marker - 4" do
    assert find_packet_marker("mjqjpqmgbljsphdztnvjfqwrcgsmlb", 4) == 7
  end

  test "find_packet_marker - 14" do
    assert find_packet_marker("mjqjpqmgbljsphdztnvjfqwrcgsmlb", 14) == 19
  end
end
