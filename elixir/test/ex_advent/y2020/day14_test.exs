defmodule ExAdvent.Y2020.Day14Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day14

  test "parse input" do
    input = ~s"""
    mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
    mem[8] = 11
    mem[7] = 101
    mem[8] = 0
    """

    assert parse_input(input) == [
             {:mask, "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"},
             {:mem, 8, 11},
             {:mem, 7, 101},
             {:mem, 8, 0}
           ]
  end

  test "apply_v1_instructions" do
    instructions = [
      {:mask, "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"},
      {:mem, 8, 11},
      {:mem, 7, 101},
      {:mem, 8, 0}
    ]

    assert apply_v1_instructions(instructions) ==
             {"XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X", %{7 => 101, 8 => 64}}
  end

  test "apply_v1_instruction - mask" do
    instruction = {:mask, "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"}
    state = {"", %{}}

    expected = {"XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X", %{}}

    assert apply_v1_instruction(instruction, state) == expected
  end

  test "apply_v1_instruction - mask with 1" do
    instruction = {:mem, 5, 4}
    state = {"XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXXXX", %{}}

    expected = {"XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXXXX", %{5 => 68}}

    assert apply_v1_instruction(instruction, state) == expected
  end

  test "apply_v1_instruction - mask with 0" do
    instruction = {:mem, 5, 4}
    state = {"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX0XX", %{}}

    expected = {"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX0XX", %{5 => 0}}

    assert apply_v1_instruction(instruction, state) == expected
  end

  test "apply_v2_instruction - mask" do
    instruction = {:mask, "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"}
    state = {"", %{}}

    expected = {'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X', %{}}

    assert apply_v2_instruction(instruction, state) == expected
  end

  test "apply_v2_instruction - mem" do
    instruction = {:mem, 42, 100}
    state = {'000000000000000000000000000000X1001X', %{}}

    expected =
      {'000000000000000000000000000000X1001X', %{26 => 100, 27 => 100, 58 => 100, 59 => 100}}

    assert apply_v2_instruction(instruction, state) == expected
  end
end
