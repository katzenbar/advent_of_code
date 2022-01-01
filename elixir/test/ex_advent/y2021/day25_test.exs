defmodule ExAdvent.Y2021.Day25Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day25

  def sample_input() do
    ~s"""
    v...>>.vv>
    .vv>>.vv..
    >>.>v>...v
    >>v>>.>.v.
    v>v.vv.v..
    >.>>..v...
    .vv..>.>v.
    v.v..>>v.v
    ....v..v.>
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() == [
             'v...>>.vv>',
             '.vv>>.vv..',
             '>>.>v>...v',
             '>>v>>.>.v.',
             'v>v.vv.v..',
             '>.>>..v...',
             '.vv..>.>v.',
             'v.v..>>v.v',
             '....v..v.>'
           ]
  end

  test "execute_step - moving right simple" do
    assert execute_step(['...>>>>.>..']) == ['...>>>.>.>.']
  end

  test "execute_step - moving right wrap around" do
    assert execute_step(['...>>>>.>.>']) == ['>..>>>.>.>.']
  end

  test "execute_step - example" do
    assert execute_step(parsed_sample_input()) == [
             '....>.>v.>',
             'v.v>.>v.v.',
             '>v>>..>v..',
             '>>v>v>.>.v',
             '.>v.v...v.',
             'v>>.>vvv..',
             '..v...>>..',
             'vv...>>vv.',
             '>.v.v..v.v'
           ]
  end

  test "find_stable_state" do
    assert find_stable_state(parsed_sample_input()) == 58
  end
end
