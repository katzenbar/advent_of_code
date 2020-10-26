defmodule ExAdvent.Y2016.Day02 do
  def solve_part1 do
    input()
    |> parse_input()
    |> find_code(part1_map())
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_code(part2_map())
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2016/day02")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn x -> String.to_charlist(x) end)
  end

  def find_code(direction_sets, keymap) do
    Enum.reduce(
      direction_sets,
      [],
      fn directions, codes ->
        [Enum.reduce(directions, List.first(codes), &move(&1, &2, keymap)) | codes]
      end
    )
    |> Enum.reverse()
    |> Enum.join()
  end

  def move(direction, position, keymap) do
    position =
      case position do
        nil -> 5
        _ -> position
      end

    Map.get(Map.get(keymap, position), direction)
  end

  def part1_map do
    %{
      1 => %{
        ?U => 1,
        ?D => 4,
        ?L => 1,
        ?R => 2
      },
      2 => %{
        ?U => 2,
        ?D => 5,
        ?L => 1,
        ?R => 3
      },
      3 => %{
        ?U => 3,
        ?D => 6,
        ?L => 2,
        ?R => 3
      },
      4 => %{
        ?U => 1,
        ?D => 7,
        ?L => 4,
        ?R => 5
      },
      5 => %{
        ?U => 2,
        ?D => 8,
        ?L => 4,
        ?R => 6
      },
      6 => %{
        ?U => 3,
        ?D => 9,
        ?L => 5,
        ?R => 6
      },
      7 => %{
        ?U => 4,
        ?D => 7,
        ?L => 7,
        ?R => 8
      },
      8 => %{
        ?U => 5,
        ?D => 8,
        ?L => 7,
        ?R => 9
      },
      9 => %{
        ?U => 6,
        ?D => 9,
        ?L => 8,
        ?R => 9
      }
    }
  end

  #     1
  #   2 3 4
  # 5 6 7 8 9
  #   A B C
  #     D
  def part2_map do
    %{
      1 => %{
        ?U => 1,
        ?D => 3,
        ?L => 1,
        ?R => 1
      },
      2 => %{
        ?U => 2,
        ?D => 6,
        ?L => 1,
        ?R => 3
      },
      3 => %{
        ?U => 1,
        ?D => 7,
        ?L => 2,
        ?R => 4
      },
      4 => %{
        ?U => 4,
        ?D => 8,
        ?L => 3,
        ?R => 4
      },
      5 => %{
        ?U => 5,
        ?D => 5,
        ?L => 5,
        ?R => 6
      },
      6 => %{
        ?U => 2,
        ?D => "A",
        ?L => 5,
        ?R => 7
      },
      7 => %{
        ?U => 3,
        ?D => "B",
        ?L => 6,
        ?R => 8
      },
      8 => %{
        ?U => 4,
        ?D => "C",
        ?L => 7,
        ?R => 9
      },
      9 => %{
        ?U => 9,
        ?D => 9,
        ?L => 8,
        ?R => 9
      },
      "A" => %{
        ?U => 6,
        ?D => "A",
        ?L => "A",
        ?R => "B"
      },
      "B" => %{
        ?U => 7,
        ?D => "D",
        ?L => "A",
        ?R => "C"
      },
      "C" => %{
        ?U => 8,
        ?D => "C",
        ?L => "B",
        ?R => "C"
      },
      "D" => %{
        ?U => "B",
        ?D => "D",
        ?L => "D",
        ?R => "D"
      }
    }
  end
end
