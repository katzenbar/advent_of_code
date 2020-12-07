defmodule ExAdvent.Y2020.Day07 do
  def solve_part1 do
    input()
    |> parse_input()
    |> build_container_map()
    |> possible_outermost_containers("shiny gold")
    |> MapSet.size()
    |> IO.puts()
  end

  def solve_part2 do
    bag_count =
      input()
      |> parse_input()
      |> build_contents_map()
      |> count_bags("shiny gold")

    # I'm counting the original shiny gold bag as well, remove that from the final answer
    IO.puts(bag_count - 1)
  end

  def input do
    File.read!("inputs/y2020/day07")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    %{"container" => container, "contains" => contains} =
      Regex.named_captures(~r/(?<container>.*) bags contain (?<contains>.*)\./, line)

    case contains do
      "no other bags" ->
        {container, []}

      _ ->
        contained_bags =
          Regex.scan(~r/(\d+) (.*?) bag/, contains)
          |> Enum.map(fn [_, count, color] ->
            {color, String.to_integer(count)}
          end)

        {container, contained_bags}
    end
  end

  def build_container_map(rule_list) do
    rule_list
    |> Enum.reduce(%{}, fn {container, contents}, containers_map ->
      Enum.reduce(contents, containers_map, fn {content_color, content_count}, containers_map ->
        Map.update(containers_map, content_color, [{container, content_count}], fn containers ->
          [{container, content_count} | containers]
        end)
      end)
    end)
  end

  def possible_outermost_containers(container_map, color, outermost_containers \\ MapSet.new()) do
    case Map.get(container_map, color) do
      nil ->
        outermost_containers

      containers ->
        Enum.reduce(
          containers,
          outermost_containers,
          fn {container_color, _}, outermost_containers ->
            case MapSet.member?(outermost_containers, container_color) do
              true ->
                outermost_containers

              false ->
                possible_outermost_containers(
                  container_map,
                  container_color,
                  MapSet.put(outermost_containers, container_color)
                )
            end
          end
        )
    end
  end

  def build_contents_map(rule_list) do
    rule_list
    |> Enum.reduce(%{}, fn {container, contents}, contents_map ->
      Map.put(contents_map, container, contents)
    end)
  end

  def count_bags(contents_map, color) do
    contained_bag_count =
      contents_map
      |> Map.get(color)
      |> Enum.map(fn {containing_color, containing_count} ->
        containing_count * count_bags(contents_map, containing_color)
      end)
      |> Enum.sum()

    contained_bag_count + 1
  end
end
