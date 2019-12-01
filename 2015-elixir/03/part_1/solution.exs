defmodule Advent do
  def input do
    { :ok, content } = File.read("input")
    String.to_char_list(content)
  end

  def deliver_presents(directions, presents_delivered \\ %{}, x \\ 0, y \\0)

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

Advent.input
|> Advent.deliver_presents
|> Map.size
|> IO.inspect
