defmodule Box do
  defstruct length: nil, width: nil, height: nil

  def ribbon_required(box) do
    ribbon_needed_to_wrap(box) + volume(box)
  end

  defp ribbon_needed_to_wrap(box) do
    2 * box.length + 2 * box.width + 2 * box.height - 2 * Enum.max([box.length, box.width, box.height])
  end

  defp volume(box) do
    box.length * box.height * box.width
  end
end

defmodule Advent do
  def input do
    { :ok, content } = File.read("input")
    String.split(content)
  end

  def get_boxes([]), do: []
  def get_boxes([ head | tail ]), do: [ parse_box(head) | get_boxes(tail) ]

  defp parse_box(box_str) do
    String.split(box_str, "x")
    |> Enum.map(&String.to_integer/1)
    |> to_box
  end

  defp to_box([ length, width, height ]), do: %Box{ length: length, width: width, height: height }
end

Advent.input
|> Advent.get_boxes
|> Enum.map(&Box.ribbon_required/1)
|> Enum.sum
|> IO.inspect
