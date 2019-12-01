defmodule Advent do
  def input do
    { :ok, content } = File.read("input")
    String.to_char_list(content)
  end

  def parse_directions(input, floor \\ 0, acc \\ [])

  def parse_directions([ ?\n | _tail ], floor, acc) do
    [ floor | acc ]
  end

  def parse_directions([ ?( | tail ], floor, acc) do
    new_floor = 1 + floor
    [ new_floor | parse_directions(tail, new_floor, acc) ]
  end

  def parse_directions([ ?) | tail ], floor, acc) do
    new_floor = -1 + floor
    [ new_floor | parse_directions(tail, new_floor, acc) ]
  end
end

Advent.input
|> Advent.parse_directions
|> Enum.find_index(fn(x) -> x == -1 end)
|> IO.puts
