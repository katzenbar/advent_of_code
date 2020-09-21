defmodule ExAdvent.Y2015.Day03Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day03

  test "> visits 2 houses" do
    assert part1('>') == 2
  end

  test "^>v< visits 4 houses" do
    assert part1('^>v<') == 4
  end

  test "^v^v^v^v^v visits 2 houses" do
    assert part1('^v^v^v^v^v') == 2
  end

  test "^v visits 3 houses" do
    assert part2('^v') == 3
  end

  test "^>v< visits 3 houses" do
    assert part2('^>v<') == 3
  end

  test "^v^v^v^v^v visits 11 houses" do
    assert part2('^v^v^v^v^v') == 11
  end
end
