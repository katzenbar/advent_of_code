defmodule Advent do
  def input do
    { :ok, content } = File.read("input")
    String.to_char_list(content)
  end

  def get_santas_directions(directions), do: Enum.chunk(directions, 2, 2, [?\n]) |> Enum.map(fn([a, _b]) -> a end)
  def get_robos_directions(directions), do: Enum.chunk(directions, 2) |> Enum.map(fn([_a, b]) -> b end)

  def deliver_presents(directions, presents_delivered \\ %{}, x \\ 0, y \\0)

  def deliver_presents([], presents_delivered, x, y), do: presents_delivered |> Map.put("#{x}.#{y}", true)
  def deliver_presents([?\n], presents_delivered, x, y), do: presents_delivered |> Map.put("#{x}.#{y}", true)

  def deliver_presents([?< | tail], presents_delivered, x, y) do
    deliver_presents(tail, presents_delivered, x - 1, y)
    |> Map.put("#{x}.#{y}", true)
  end

  def deliver_presents([?> | tail], presents_delivered, x, y) do
    deliver_presents(tail, presents_delivered, x + 1, y)
    |> Map.put("#{x}.#{y}", true)
  end

  def deliver_presents([?v | tail], presents_delivered, x, y) do
    deliver_presents(tail, presents_delivered, x, y - 1)
    |> Map.put("#{x}.#{y}", true)
  end

  def deliver_presents([?^ | tail], presents_delivered, x, y) do
    deliver_presents(tail, presents_delivered, x, y + 1)
    |> Map.put("#{x}.#{y}", true)
  end
end

santas_deliveries = Advent.input
|> Advent.get_santas_directions
|> Advent.deliver_presents

Advent.input
|> Advent.get_robos_directions
|> Advent.deliver_presents(santas_deliveries)
|> Map.size
|> IO.inspect
