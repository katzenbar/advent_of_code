# https://en.wikipedia.org/wiki/Zipper_(data_structure)

defmodule ExAdvent.Util.CircleZipper do
  def new(value) do
    {[], value, []}
  end

  def current_value({_, value, _}), do: value

  def insert(zipper, value) do
    {left, current_value, right} = zipper
    {[current_value | left], value, right}
  end

  def remove({[], _, []}), do: raise(ArgumentError, message: "cannot remove the last element")

  def remove(zipper = {_, _, []}) do
    {left, _, _} = zipper
    [value | left] = Enum.reverse(left)
    {[], value, left}
  end

  def remove(zipper) do
    {left, _, [value | right]} = zipper
    {left, value, right}
  end

  def rotate_cw(zipper = {[], _, []}), do: zipper

  def rotate_cw(zipper = {_, _, []}) do
    {left, current_value, _} = zipper
    [value | left] = Enum.reverse(left)
    {[current_value], value, left}
  end

  def rotate_cw(zipper) do
    {left, current_value, [value | right]} = zipper
    {[current_value | left], value, right}
  end

  def rotate_ccw(zipper = {[], _, []}), do: zipper

  def rotate_ccw(zipper = {[], _, _}) do
    {_, current_value, right} = zipper
    [value | right] = Enum.reverse(right)
    {right, value, [current_value]}
  end

  def rotate_ccw(zipper) do
    {[value | left], current_value, right} = zipper
    {left, value, [current_value | right]}
  end

  def to_list(zipper) do
    {left, current_value, right} = zipper
    Enum.concat(Enum.reverse(left), [current_value | right])
  end
end
