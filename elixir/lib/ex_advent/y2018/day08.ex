defmodule ExAdvent.Y2018.Day08 do
  def solve_part1 do
    input()
    |> parse_input()
    |> sum_metadata()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> calculate_root_value()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2018/day08")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  def sum_metadata(list) do
    list
    |> build_tree()
    |> elem(0)
    |> List.flatten()
    |> Enum.sum()
  end

  def build_tree([]), do: []

  def build_tree([0 | [num_metadata | rest]]) do
    {metadata, rest} = Enum.split(rest, num_metadata)
    {[metadata], rest}
  end

  def build_tree([num_children | [num_metadata | rest]]) do
    {children, rest} =
      Enum.reduce(1..num_children, {[], rest}, fn _, {children, rest} ->
        {tree, rest} = build_tree(rest)
        {[tree | children], rest}
      end)

    {metadata, rest} = Enum.split(rest, num_metadata)

    {[metadata, Enum.reverse(children)], rest}
  end

  def calculate_root_value(list) do
    list
    |> build_tree()
    |> elem(0)
    |> calculate_tree_value()
    |> elem(0)
  end

  def calculate_tree_value([metadata | []]) do
    {Enum.sum(metadata), [metadata]}
  end

  def calculate_tree_value([metadata, children]) do
    Enum.reduce(metadata, {0, children}, fn idx, {sum, children} ->
      case Enum.at(children, idx - 1) do
        nil ->
          {sum, children}

        child_tree ->
          {child_value, _} = calculate_tree_value(child_tree)
          children = List.replace_at(children, idx - 1, [[child_value]])

          {sum + child_value, children}
      end
    end)
  end
end
