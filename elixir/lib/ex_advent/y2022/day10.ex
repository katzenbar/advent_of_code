defmodule ExAdvent.Y2022.Day10 do
  def solve_part1 do
    input()
    |> parse_input()
    |> get_signal_strengths(20, 40)
    |> Enum.sum()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> draw_image()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2022/day10")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_command/1)
  end

  def parse_command("noop"), do: {:noop}
  def parse_command("addx " <> amount), do: {:addx, String.to_integer(amount)}

  def get_signal_strengths(commands, start, step) do
    commands
    |> run_commands()
    |> Enum.drop(start - 1)
    |> Enum.take_every(step)
    |> Enum.map(fn {a, b} -> a * b end)
  end

  def draw_image(commands) do
    commands
    |> run_commands()
    |> Enum.map(fn {cycle, x} ->
      if abs(rem(cycle - 1, 40) - x) < 2, do: "#", else: "."
    end)
    |> Enum.take(240)
    |> Enum.chunk_every(40)
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.join("\n")
  end

  def run_commands(commands) do
    states =
      commands
      |> Enum.flat_map_reduce({1, 1}, fn command, state ->
        state = run_command(command, state)
        {state, List.last(state)}
      end)
      |> elem(0)

    [{1, 1} | states]
  end

  def run_command({:noop}, {cycle, x}), do: [{cycle + 1, x}]
  def run_command({:addx, val}, {cycle, x}), do: [{cycle + 1, x}, {cycle + 2, x + val}]
end
