defmodule ExAdvent.Y2021.Day10 do
  def solve_part1 do
    input()
    |> parse_input()
    |> get_syntax_error_score()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> get_middle_autocomplete_score()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day10")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
  end

  def get_syntax_error_score(input_lines) do
    input_lines
    |> Enum.map(&parse_line/1)
    |> Enum.filter(fn {state, _} -> state == :invalid end)
    |> Enum.map(fn {_, ch} -> ch end)
    |> Enum.map(&score_for_illegal_character/1)
    |> Enum.sum()
  end

  def get_middle_autocomplete_score(input_lines) do
    autocomplete_scores =
      input_lines
      |> get_autocomplete_scores()
      |> Enum.sort()

    middle_idx = floor(length(autocomplete_scores) / 2)

    Enum.at(autocomplete_scores, middle_idx)
  end

  def get_autocomplete_scores(input_lines) do
    input_lines
    |> Enum.map(&parse_line/1)
    |> Enum.filter(fn {state, remaining_stack} -> state == :remaining && remaining_stack != [] end)
    |> Enum.map(fn {_, remaining_stack} -> remaining_stack end)
    |> Enum.map(&build_completion_string/1)
    |> Enum.map(&score_completion_string/1)
  end

  def parse_line(line) do
    line
    |> String.to_charlist()
    |> Enum.reduce_while({:remaining, []}, fn
      ch, {:remaining, []} ->
        {:cont, {:remaining, [ch]}}

      ch, {_, acc} ->
        [last_open | rest] = acc

        cond do
          ch == ?[ || ch == ?( || ch == ?< || ch == ?{ ->
            {:cont, {:remaining, [ch | acc]}}

          (last_open == ?[ && ch == ?]) ||
            (last_open == ?( && ch == ?)) ||
            (last_open == ?< && ch == ?>) ||
              (last_open == ?{ && ch == ?}) ->
            {:cont, {:remaining, rest}}

          true ->
            {:halt, {:invalid, ch}}
        end
    end)
  end

  defp score_for_illegal_character(ch) do
    case ch do
      ?) -> 3
      ?] -> 57
      ?} -> 1197
      ?> -> 25137
    end
  end

  defp build_completion_string(remaining_stack) do
    Enum.map(remaining_stack, fn
      ?( -> ?)
      ?[ -> ?]
      ?{ -> ?}
      ?< -> ?>
    end)
  end

  defp score_completion_string(completion_string) do
    Enum.reduce(completion_string, 0, fn ch, score ->
      score = 5 * score

      case ch do
        ?) -> score + 1
        ?] -> score + 2
        ?} -> score + 3
        ?> -> score + 4
      end
    end)
  end
end
