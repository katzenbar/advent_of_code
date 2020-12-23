defmodule ExAdvent.Y2020.Day23 do
  def solve_part1 do
    input()
    |> parse_input()
    |> perform_moves(100)
    |> find_labels_after_one()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> add_more_cups(1_000_000)
    |> perform_moves(10_000_000, 1_000_000)
    |> find_my_stars()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day23")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.to_charlist()
    |> Enum.map(&(&1 - ?0))
  end

  def build_map(list) do
    list
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {x, idx}, acc ->
      Map.put(acc, x, Enum.at(list, rem(idx + 1, 9)))
    end)
  end

  def add_more_cups(starting_cups, total_cups) do
    map = build_map(starting_cups)

    last_key = List.last(starting_cups)
    last_value = Map.get(map, last_key)

    cup_map =
      Enum.reduce(10..(total_cups - 1), map, fn x, acc -> Map.put(acc, x, x + 1) end)
      |> Map.put(last_key, 10)
      |> Map.put(total_cups, last_value)

    {cup_map, List.first(starting_cups)}
  end

  def find_labels_after_one(cups) do
    cups = get_cup_list(cups)
    one_index = Enum.find_index(cups, &(&1 == 1))
    {before_one, after_one} = Enum.split(cups, one_index + 1)

    Enum.concat([after_one, Enum.slice(before_one, 0..-2)])
    |> Enum.join("")
  end

  def find_my_stars({cup_map, _}) do
    first = Map.get(cup_map, 1)
    second = Map.get(cup_map, first)

    first * second
  end

  def perform_moves(cups, times) do
    cup_map = build_map(cups)
    current_cup = List.first(cups)
    perform_moves({cup_map, current_cup}, times, Enum.max(cups))
  end

  def perform_moves(cups, times, max_cup) do
    Enum.reduce(1..times, cups, fn _, cups ->
      perform_move(cups, max_cup)
    end)
  end

  def perform_move({cup_map, current_cup}, max_cup) do
    pickup_start = Map.get(cup_map, current_cup)
    pickup_middle = Map.get(cup_map, pickup_start)
    pickup_end = Map.get(cup_map, pickup_middle)
    next_current = Map.get(cup_map, pickup_end)

    destination_cup =
      get_destination_cup(current_cup, [pickup_start, pickup_middle, pickup_end], max_cup)

    after_destination_cup = Map.get(cup_map, destination_cup)

    cup_map =
      cup_map
      |> Map.put(current_cup, next_current)
      |> Map.put(destination_cup, pickup_start)
      |> Map.put(pickup_end, after_destination_cup)

    {cup_map, next_current}
  end

  @spec get_destination_cup(number, any, any) :: any
  def get_destination_cup(1, picked_up, max_cup) do
    get_destination_cup(max_cup + 1, picked_up, max_cup)
  end

  def get_destination_cup(current_cup, picked_up, max_cup) do
    case Enum.member?(picked_up, current_cup - 1) do
      true ->
        get_destination_cup(current_cup - 1, picked_up, max_cup)

      false ->
        current_cup - 1
    end
  end

  def find_destination_cup(1, cups, _) do
    Enum.max(cups)
  end

  def find_destination_cup(current_cup, cups, picked_up) do
    case Enum.member?(picked_up, current_cup - 1) do
      true ->
        find_destination_cup(current_cup - 1, cups, picked_up)

      false ->
        current_cup - 1
    end
  end

  def get_cup_list({cup_map, current}) do
    Enum.reduce(1..8, {current, [current]}, fn _, {c, cups} ->
      next = Map.get(cup_map, c)
      {next, [next | cups]}
    end)
    |> elem(1)
    |> Enum.reverse()
  end
end
