# From github user bheeshmar's comment on https://gist.github.com/10nin/5713366
defmodule Crypto do
  def md5(data) do
    Base.encode16(:erlang.md5(data), case: :lower)
  end
end

defmodule Advent do
  @key "yzbqklnj"

  def generate_hash(num), do: Crypto.md5(@key <> Integer.to_string(num))

  def is_advent_coin?(num), do: generate_hash(num) |> String.starts_with?("00000")

  def get_next_advent_coin(starting_number) do
    if is_advent_coin?(starting_number) do
      starting_number
    else
      get_next_advent_coin(starting_number + 1)
    end
  end
end

Advent.get_next_advent_coin(0)
|> IO.inspect
