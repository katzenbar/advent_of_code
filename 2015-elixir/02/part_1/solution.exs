defmodule Box do
  defstruct length: nil, width: nil, height: nil

  def paper_required(box) do
    side1 = box.length * box.width
    side2 = box.width * box.height
    side3 = box.height * box.length

    2 * side1 + 2 * side2 + 2 * side3 + Enum.min([side1, side2, side3])
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
|> Enum.map(&Box.paper_required/1)
|> Enum.sum
|> IO.inspect
