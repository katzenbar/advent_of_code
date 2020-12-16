defmodule ExAdvent.Y2020.Day16 do
  def solve_part1 do
    input()
    |> parse_input()
    |> nearby_ticket_scanning_error_rate()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_departure_values()
    |> Enum.reduce(&*/2)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day16")
  end

  def parse_input(input) do
    [fields, mine, nearby] =
      input
      |> String.trim()
      |> String.split("\n\n")

    %{
      fields: parse_fields(fields),
      mine: List.first(parse_tickets(mine)),
      nearby: parse_tickets(nearby)
    }
  end

  def parse_fields(fields) do
    fields
    |> String.split("\n")
    |> Enum.map(fn line ->
      %{"c" => c, "a_low" => a_low, "a_high" => a_high, "b_low" => b_low, "b_high" => b_high} =
        Regex.named_captures(
          ~r/(?<c>.*): (?<a_low>\d+)-(?<a_high>\d+) or (?<b_low>\d+)-(?<b_high>\d+)/,
          line
        )

      {c, String.to_integer(a_low)..String.to_integer(a_high),
       String.to_integer(b_low)..String.to_integer(b_high)}
    end)
  end

  def parse_tickets(tickets) do
    tickets
    |> String.split("\n")
    |> Enum.slice(1..-1)
    |> Enum.map(fn ticket ->
      ticket
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def nearby_ticket_scanning_error_rate(state) do
    %{fields: fields, nearby: nearby} = state

    valid_numbers =
      Enum.reduce(fields, MapSet.new(), fn {_, r1, r2}, acc ->
        acc
        |> MapSet.union(MapSet.new(r1))
        |> MapSet.union(MapSet.new(r2))
      end)

    nearby
    |> Enum.flat_map(fn ticket ->
      Enum.filter(ticket, fn num -> !MapSet.member?(valid_numbers, num) end)
    end)
    |> Enum.sum()
  end

  def valid_nearby_tickets(state) do
    %{fields: fields, nearby: nearby} = state

    valid_numbers =
      Enum.reduce(fields, MapSet.new(), fn {_, r1, r2}, acc ->
        acc
        |> MapSet.union(MapSet.new(r1))
        |> MapSet.union(MapSet.new(r2))
      end)

    nearby
    |> Enum.filter(fn ticket ->
      Enum.all?(ticket, fn num -> MapSet.member?(valid_numbers, num) end)
    end)
  end

  def find_field_positions(state) do
    %{fields: fields, mine: mine} = state

    fields_to_check = Enum.map(mine, fn _ -> fields end)

    valid_nearby_tickets(state)
    |> Enum.reduce(fields_to_check, fn ticket, fields_to_check ->
      fields_to_check
      |> Enum.zip(ticket)
      |> Enum.map(fn {fields, value} -> Enum.filter(fields, &valid_for_field?(&1, value)) end)
    end)
    |> assign_fields()
  end

  def valid_for_field?({_, r1, r2}, value) do
    Enum.member?(r1, value) || Enum.member?(r2, value)
  end

  def assign_fields(possible_fields) do
    cond do
      Enum.all?(possible_fields, &(Enum.count(&1) == 1)) ->
        List.flatten(possible_fields)

      true ->
        single_possibilities =
          Enum.filter(possible_fields, &(Enum.count(&1) == 1))
          |> List.flatten()
          |> MapSet.new()

        possible_fields
        |> Enum.map(fn possible_at_position ->
          cond do
            Enum.count(possible_at_position) == 1 ->
              possible_at_position

            true ->
              Enum.reject(possible_at_position, &MapSet.member?(single_possibilities, &1))
          end
        end)
        |> assign_fields()
    end
  end

  def find_departure_values(state) do
    %{mine: mine} = state
    fields = find_field_positions(state)

    Enum.zip(mine, fields)
    |> Enum.filter(fn {_, {field_name, _, _}} -> String.contains?(field_name, "departure") end)
    |> Enum.map(fn {value, _} -> value end)
  end
end
