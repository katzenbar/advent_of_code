defmodule Advent do
  def perfect_light_display do
    light_map = %{}

    instructions
    |> Enum.reduce(light_map, fn (i, acc) -> run_instruction(i, acc) end)
  end

  defp instructions do
    input
    |> Enum.map(&parse_instruction/1)
  end

  defp parse_instruction(str) do
    coordinates = Regex.named_captures(~r/(?<x0>\d{1,3}),(?<y0>\d{1,3}) through (?<x1>\d{1,3}),(?<y1>\d{1,3})/, str)

    %{
      action: parse_action(str),
      x0: String.to_integer(coordinates["x0"]),
      y0: String.to_integer(coordinates["y0"]),
      x1: String.to_integer(coordinates["x1"]),
      y1: String.to_integer(coordinates["y1"]),
    }
  end

  defp parse_action(str) do
    cond do
      String.starts_with?(str, "turn off") ->
        :off
      String.starts_with?(str, "turn on") ->
        :on
      String.starts_with?(str, "toggle") ->
        :toggle
    end
  end

  defp input do
    { :ok, content } = File.read("input")
    String.split(content, "\n", trim: true)
  end

  defp run_instruction(instruction, light_map) do
    IO.inspect "#{instruction[:action]} - #{instruction[:x0]}, #{instruction[:y0]} through #{instruction[:x1]}, #{instruction[:y1]}"
    keys_for_actionable_lights(instruction)
    |> Enum.reduce(light_map, fn(key, map) -> manipulate_light(key, map, instruction[:action]) end)
  end

  defp keys_for_actionable_lights(instruction) do
    Range.new(instruction[:x0], instruction[:x1])
    |> Enum.to_list
    |> Enum.flat_map(fn(x) ->
        Range.new(instruction[:y0], instruction[:y1])
        |> Enum.to_list
        |> Enum.map(fn(y) -> "#{x}-#{y}" end)
      end
    )
  end

  defp manipulate_light(key, light_map, :on) do
    Map.put(light_map, key, true)
  end

  defp manipulate_light(key, light_map, :off) do
    Map.put(light_map, key, false)
  end

  defp manipulate_light(key, light_map, :toggle) do
    Map.put(light_map, key, !light_map[key])
  end
end

Advent.perfect_light_display
|> Map.values
|> Enum.count(&(&1)) # Count only true values
|> IO.inspect
