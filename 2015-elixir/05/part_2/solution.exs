defmodule Advent do
  def contains_repeating_pair?(string) do
    String.match?(string, ~r/(..).*\1/)
  end

  def contains_slamwich?(string) do
    String.match?(string, ~r/(.).\1/)
  end

  def is_nice_string?(string) do
    [
      contains_repeating_pair?(string),
      contains_slamwich?(string),
    ]
    |> Enum.all?
  end

  def input do
    { :ok, content } = File.read("input")
    String.split(content)
  end
end

Advent.input
|> Enum.map(&Advent.is_nice_string?/1)
|> Enum.filter(&(&1))
|> Enum.count
|> IO.inspect
