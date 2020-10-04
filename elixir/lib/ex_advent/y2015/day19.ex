defmodule ExAdvent.Y2015.Day19 do
  def solve_part1 do
    input()
    |> parse_input()
    |> possible_replacements()
    |> Enum.count()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> steps_to_generate_molecule()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2015/day19")
  end

  def parse_input(input) do
    [replacements, molecule] =
      input
      |> String.trim()
      |> String.split("\n\n")

    replacement_list =
      replacements
      |> String.split("\n")
      |> Enum.map(&String.split(&1, " => "))

    {molecule, replacement_list}
  end

  def possible_replacements({molecule, replacement_list}) do
    element_list = molecule_to_element_list(molecule)

    replacement_list
    |> Enum.flat_map(fn replacement -> replacements_in_element_list(element_list, replacement) end)
    |> Enum.uniq()
  end

  def molecule_to_element_list(molecule) do
    molecule
    |> String.split(~r/([A-Z][a-z]?)/, trim: true, include_captures: true)
  end

  def replacements_in_element_list(element_list, [source_element, replacement_elements]) do
    element_list
    |> Enum.with_index()
    |> Enum.reduce([], fn {el, idx}, replacements ->
      case el == source_element do
        true ->
          replaced_molecule =
            element_list |> List.replace_at(idx, replacement_elements) |> Enum.join("")

          [replaced_molecule | replacements]

        false ->
          replacements
      end
    end)
  end

  def steps_to_generate_molecule({target_molecule, replacement_list}) do
    steps_to_generate_value("e", target_molecule, fn molecule ->
      possible_reverse_replacements({molecule, replacement_list})
    end)
  end

  @spec possible_reverse_replacements({any, any}) :: [any]
  def possible_reverse_replacements({molecule, replacement_list}) do
    replacement_list
    |> Enum.flat_map(fn replacement -> replacements_in_molecule(molecule, replacement) end)
    |> Enum.uniq()
  end

  def replacements_in_molecule(molecule, [source_element, replacement_elements]) do
    element_list =
      molecule
      |> String.split(~r/#{replacement_elements}/, trim: true, include_captures: true)

    element_list
    |> Enum.with_index()
    |> Enum.reduce([], fn {el, idx}, replacements ->
      case el == replacement_elements do
        true ->
          replaced_molecule =
            element_list |> List.replace_at(idx, source_element) |> Enum.join("")

          [replaced_molecule | replacements]

        false ->
          replacements
      end
    end)
  end

  def steps_to_generate_value(
        target_value,
        current_value,
        next_values_fn,
        num_steps \\ 0
      ) do
    cond do
      current_value == target_value ->
        num_steps

      true ->
        next_value = next_values_fn.(current_value) |> Enum.min_by(fn x -> String.length(x) end)

        steps_to_generate_value(
          target_value,
          next_value,
          next_values_fn,
          num_steps + 1
        )
    end
  end
end
