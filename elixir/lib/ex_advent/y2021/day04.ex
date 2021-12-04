defmodule ExAdvent.Y2021.Day04 do
  def solve_part1 do
    input()
    |> parse_input()
    |> get_first_winning_score()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> get_last_winning_score()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day04")
  end

  def parse_input(input) do
    [[drawn_numbers] | boards] =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.chunk_by(&(&1 == ""))
      |> Enum.filter(&(&1 != [""]))

    {parse_drawn_numbers(drawn_numbers), parse_boards(boards)}
  end

  def parse_drawn_numbers(drawn_numbers) do
    drawn_numbers
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def parse_boards(boards) do
    Enum.map(boards, &parse_board/1)
  end

  def parse_board(board) do
    board
    |> Enum.map(fn row ->
      row
      |> String.trim()
      |> String.split(~r/ +/)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def get_first_winning_score(game) do
    {drawn_numbers, winning_board} = find_first_winning_board(game)
    score_board(drawn_numbers, winning_board)
  end

  def find_first_winning_board({drawn_numbers, boards}) do
    boards_with_sets = build_winning_sets_for_boards(boards)

    drawn_numbers
    |> Enum.reduce_while([], fn next_drawn_number, previous_drawn_numbers ->
      drawn_numbers = [next_drawn_number | previous_drawn_numbers]
      winning_boards = find_winning_boards(drawn_numbers, boards_with_sets)

      cond do
        length(winning_boards) > 0 ->
          {:halt, {drawn_numbers, List.first(winning_boards)}}

        true ->
          {:cont, drawn_numbers}
      end
    end)
  end

  def get_last_winning_score(game) do
    {drawn_numbers, winning_board} = find_last_winning_board(game)
    score_board(drawn_numbers, winning_board)
  end

  def find_last_winning_board({drawn_numbers, boards}) do
    boards_with_sets = build_winning_sets_for_boards(boards)

    drawn_numbers
    |> Enum.reduce_while({[], boards_with_sets}, fn next_drawn_number, {previous_drawn_numbers, boards_with_sets} ->
      drawn_numbers = [next_drawn_number | previous_drawn_numbers]
      winning_boards = find_winning_boards(drawn_numbers, boards_with_sets)

      boards_with_sets =
        Enum.filter(boards_with_sets, fn {board, _} ->
          Enum.all?(winning_boards, &(&1 != board))
        end)

      cond do
        length(boards_with_sets) == 0 ->
          {:halt, {drawn_numbers, List.first(winning_boards)}}

        true ->
          {:cont, {drawn_numbers, boards_with_sets}}
      end
    end)
  end

  def build_winning_sets_for_boards(boards) do
    boards
    |> Enum.map(fn board ->
      columns =
        board
        |> Enum.zip()
        |> Enum.map(&Tuple.to_list/1)

      sets = Enum.concat(board, columns) |> Enum.map(&MapSet.new/1)

      {board, sets}
    end)
  end

  def find_winning_boards(drawn_numbers, boards_with_sets) do
    drawn_set = MapSet.new(drawn_numbers)

    boards_with_sets
    |> Enum.filter(fn {_, winning_sets} ->
      Enum.any?(winning_sets, &MapSet.subset?(&1, drawn_set))
    end)
    |> Enum.map(&elem(&1, 0))
  end

  def score_board(drawn_numbers, board) do
    last_called = List.first(drawn_numbers)

    drawn_set = MapSet.new(drawn_numbers)

    uncalled_sum =
      board
      |> List.flatten()
      |> Enum.filter(&(!MapSet.member?(drawn_set, &1)))
      |> Enum.sum()

    uncalled_sum * last_called
  end
end
