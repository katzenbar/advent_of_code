defmodule ExAdvent.Y2016.Day08 do
  def solve_part1 do
    input()
    |> parse_input()
    |> Enum.reduce(build_grid(50, 6), &execute_instruction/2)
    |> List.flatten()
    |> Enum.sum()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> Enum.reduce(build_grid(50, 6), &execute_instruction/2)
    |> print_grid()
  end

  def input do
    File.read!("inputs/y2016/day08")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def build_grid(width, height) do
    1..height
    |> Enum.map(fn _ ->
      Enum.map(1..width, fn _ -> 0 end)
    end)
  end

  def parse_line("rect " <> rest) do
    %{"w" => w, "h" => h} = Regex.named_captures(~r/(?<w>\d+)x(?<h>\d+)/, rest)
    {:rect, String.to_integer(w), String.to_integer(h)}
  end

  def parse_line("rotate row " <> rest) do
    %{"row" => row, "amt" => amt} = Regex.named_captures(~r/y=(?<row>\d+) by (?<amt>\d+)/, rest)
    {:rotate_row, String.to_integer(row), String.to_integer(amt)}
  end

  def parse_line("rotate column " <> rest) do
    %{"col" => col, "amt" => amt} = Regex.named_captures(~r/x=(?<col>\d+) by (?<amt>\d+)/, rest)
    {:rotate_col, String.to_integer(col), String.to_integer(amt)}
  end

  def execute_instruction({:rect, w, h}, grid) do
    0..(Enum.count(grid) - 1)
    |> Enum.map(fn hi ->
      0..(Enum.count(List.first(grid)) - 1)
      |> Enum.map(fn wi ->
        cond do
          hi < h && wi < w -> 1
          true -> Enum.at(grid, hi) |> Enum.at(wi)
        end
      end)
    end)
  end

  def execute_instruction({:rotate_row, index, amount}, grid) do
    row = Enum.at(grid, index)
    width = Enum.count(row)

    new_row =
      Enum.map(0..(width - 1), fn i ->
        Enum.at(row, rem(i - amount, width))
      end)

    List.replace_at(grid, index, new_row)
  end

  def execute_instruction({:rotate_col, column_index, amount}, grid) do
    height = Enum.count(grid)

    grid
    |> Enum.with_index()
    |> Enum.map(fn {row, row_index} ->
      new_val = grid |> Enum.at(rem(row_index - amount, height)) |> Enum.at(column_index)
      List.replace_at(row, column_index, new_val)
    end)
  end

  def print_grid(grid) do
    Enum.each(grid, fn row ->
      row
      |> Enum.map(fn x ->
        case x do
          0 -> " "
          1 -> "#"
        end
      end)
      |> Enum.join("")
      |> IO.puts()
    end)
  end
end
