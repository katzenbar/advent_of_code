defmodule ExAdvent.Y2021.Day03 do
  def solve_part1 do
    input()
    |> parse_input()
    |> get_power_consumption()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> get_life_support_rating()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day03")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_charlist/1)
  end

  def get_power_consumption(input) do
    get_gamma_rate(input) * get_epsilon_rate(input)
  end

  def get_life_support_rating(input) do
    get_oxygen_generator_rating(input) * get_c02_scrubber_rating(input)
  end

  def get_gamma_rate(input), do: get_power_consumption_component(input, :most_common)

  def get_epsilon_rate(input), do: get_power_consumption_component(input, :least_common)

  def get_power_consumption_component(input, most_or_least_common_bit) do
    bitstring_length = length(List.first(input))

    Enum.map(0..(bitstring_length - 1), fn position ->
      find_bit_in_position(input, position, most_or_least_common_bit)
    end)
    |> to_string()
    |> String.to_integer(2)
  end

  def get_oxygen_generator_rating(input), do: get_life_support_rating_component(input, :most_common)
  def get_c02_scrubber_rating(input), do: get_life_support_rating_component(input, :least_common)

  def get_life_support_rating_component(input, most_or_least_common_bit) do
    bitstring_length = length(List.first(input))

    Enum.reduce(0..(bitstring_length - 1), input, fn
      _, [rating] ->
        [rating]

      position, remaining_numbers ->
        bit = find_bit_in_position(remaining_numbers, position, most_or_least_common_bit)
        Enum.filter(remaining_numbers, fn number -> Enum.at(number, position) == bit end)
    end)
    |> List.first()
    |> to_string()
    |> String.to_integer(2)
  end

  defp find_bit_in_position(input, position, most_or_least_common_bit) do
    bits_in_positon = Enum.map(input, fn characters -> Enum.at(characters, position) end)
    num_ones = Enum.count(bits_in_positon, &(&1 == ?1))

    case most_or_least_common_bit do
      :most_common -> if num_ones >= length(bits_in_positon) / 2, do: ?1, else: ?0
      :least_common -> if num_ones < length(bits_in_positon) / 2, do: ?1, else: ?0
    end
  end
end
