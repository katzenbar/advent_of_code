defmodule ExAdvent.Y2020.Day08Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day08

  test "parse input" do
    input = ~s"""
    nop +0
    acc +1
    jmp +4
    acc +3
    jmp -3
    acc -99
    acc +1
    jmp -4
    acc +6
    """

    assert parse_input(input) == %{
             accumulator: 0,
             execution_pointer: 0,
             instructions: [
               nop: 0,
               acc: 1,
               jmp: 4,
               acc: 3,
               jmp: -3,
               acc: -99,
               acc: 1,
               jmp: -4,
               acc: 6
             ]
           }
  end

  test "execute_next_instruction - noop" do
    system = %{
      accumulator: 0,
      execution_pointer: 0,
      instructions: [
        nop: 0,
        acc: 1
      ]
    }

    assert execute_next_instruction(system) == %{
             accumulator: 0,
             execution_pointer: 1,
             instructions: [
               nop: 0,
               acc: 1
             ]
           }
  end

  test "execute_next_instruction - acc" do
    system = %{
      accumulator: 0,
      execution_pointer: 1,
      instructions: [
        nop: 0,
        acc: 1
      ]
    }

    assert execute_next_instruction(system) == %{
             accumulator: 1,
             execution_pointer: 2,
             instructions: [
               nop: 0,
               acc: 1
             ]
           }
  end

  test "execute_next_instruction - jmp" do
    system = %{
      accumulator: 0,
      execution_pointer: 2,
      instructions: [
        nop: 0,
        acc: 1,
        jmp: -2
      ]
    }

    assert execute_next_instruction(system) == %{
             accumulator: 0,
             execution_pointer: 0,
             instructions: [
               nop: 0,
               acc: 1,
               jmp: -2
             ]
           }
  end

  test "execute_loop_once" do
    system = %{
      accumulator: 0,
      execution_pointer: 0,
      instructions: [
        nop: 0,
        acc: 1,
        jmp: 4,
        acc: 3,
        jmp: -3,
        acc: -99,
        acc: 1,
        jmp: -4,
        acc: 6
      ]
    }

    assert execute_loop_once(system) == %{
             accumulator: 5,
             execution_pointer: 1,
             instructions: [
               nop: 0,
               acc: 1,
               jmp: 4,
               acc: 3,
               jmp: -3,
               acc: -99,
               acc: 1,
               jmp: -4,
               acc: 6
             ]
           }
  end

  test "fix_program" do
    system = %{
      accumulator: 0,
      execution_pointer: 0,
      instructions: [
        nop: 0,
        acc: 1,
        jmp: 4,
        acc: 3,
        jmp: -3,
        acc: -99,
        acc: 1,
        jmp: -4,
        acc: 6
      ]
    }

    assert fix_program(system) == %{
             accumulator: 8,
             execution_pointer: 9,
             instructions: [
               nop: 0,
               acc: 1,
               jmp: 4,
               acc: 3,
               jmp: -3,
               acc: -99,
               acc: 1,
               nop: -4,
               acc: 6
             ]
           }
  end
end
