defmodule ExAdvent.Y2021.Day07Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day07

  def crab_positions() do
    [16, 1, 2, 0, 4, 2, 7, 1, 2, 14]
  end

  test "parse input" do
    input = "16,1,2,0,4,2,7,1,2,14"
    assert parse_input(input) == crab_positions()
  end

  test "min_fuel_required_to_align - constant" do
    assert min_fuel_required_to_align(crab_positions(), &fuel_required_to_align_on_position_constant_rate/2) == 37
  end

  test "min_fuel_required_to_align - increasing" do
    assert min_fuel_required_to_align(crab_positions(), &fuel_required_to_align_on_position_increasing_rate/2) == 168
  end

  test "fuel_required_to_align_on_position_constant_rate - 1" do
    assert fuel_required_to_align_on_position_constant_rate(1, crab_positions()) == 41
  end

  test "fuel_required_to_align_on_position_constant_rate - 2" do
    assert fuel_required_to_align_on_position_constant_rate(2, crab_positions()) == 37
  end

  test "fuel_required_to_align_on_position_constant_rate - 3" do
    assert fuel_required_to_align_on_position_constant_rate(3, crab_positions()) == 39
  end

  test "fuel_required_to_align_on_position_constant_rate - 10" do
    assert fuel_required_to_align_on_position_constant_rate(10, crab_positions()) == 71
  end

  test "fuel_required_to_align_on_position_increasing_rate - 2" do
    assert fuel_required_to_align_on_position_increasing_rate(2, crab_positions()) == 206
  end

  test "fuel_required_to_align_on_position_increasing_rate - 5" do
    assert fuel_required_to_align_on_position_increasing_rate(5, crab_positions()) == 168
  end
end
