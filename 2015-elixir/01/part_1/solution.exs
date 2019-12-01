defmodule Advent do
  def input do
    { :ok, content } = File.read("input")
    String.to_char_list(content)
  end

  def parse_directions([ ?\n | _tail ]), do: 0
  def parse_directions([ ?( | tail ]), do: 1 + parse_directions(tail)
  def parse_directions([ ?) | tail ]), do: -1 + parse_directions(tail)
end

Advent.input |> Advent.parse_directions |> IO.puts
