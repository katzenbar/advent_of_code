defmodule ExAdvent.Y2022.Day05 do
  def solve_part1 do
    input()
    |> parse_input()
    |> move_crates(false)
    |> get_top_crates()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> move_crates(true)
    |> get_top_crates()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2022/day05")
  end

  def parse_input(input) do
    [crates, instructions] =
      input
      |> String.trim_trailing()
      |> String.split("\n\n")

    {parse_crates_input(crates), parse_instructions_input(instructions)}
  end

  def parse_crates_input(input) do
    crates_and_ids =
      input
      |> String.split("\n")
      |> Enum.map(&parse_crates_input_line/1)

    [ids | crates] = Enum.reverse(crates_and_ids)
    num_stacks = length(ids)

    crates
    |> Enum.map(fn line ->
      line
      |> Enum.chunk_every(num_stacks, num_stacks, Stream.cycle([""]))
      |> Enum.at(0)
    end)
    |> Enum.reverse()
    |> Enum.zip()
    |> Enum.map(fn x ->
      x
      |> Tuple.to_list()
      |> Enum.filter(fn y -> y != "" end)
    end)
  end

  def parse_crates_input_line(line) do
    line
    |> String.to_charlist()
    |> Enum.chunk_every(4)
    |> Enum.map(fn crate ->
      crate
      |> to_string()
      |> String.trim()
      |> String.replace(~r/[\[\] ]/, "")
    end)
  end

  def parse_instructions_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_instructions_input_line/1)
  end

  def parse_instructions_input_line(line) do
    line
    |> String.replace(~r/(move|from|to)/, "")
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def move_crates({crates, instructions}, can_move_multiple) do
    instructions
    |> Enum.reduce(crates, &move_crates_with_instruction(&1, &2, can_move_multiple))
  end

  def move_crates_with_instruction(instruction, crates, can_move_multiple) do
    [num_to_move, from_id, to_id] = instruction

    {to_move, leave} =
      crates
      |> Enum.at(from_id - 1)
      |> Enum.split(num_to_move)

    to_move = if can_move_multiple, do: to_move, else: Enum.reverse(to_move)
    new_to_stack = Enum.concat(to_move, Enum.at(crates, to_id - 1))

    crates
    |> List.replace_at(from_id - 1, leave)
    |> List.replace_at(to_id - 1, new_to_stack)
  end

  def get_top_crates(crates) do
    crates
    |> Enum.map(&List.first/1)
    |> Enum.join("")
  end
end
