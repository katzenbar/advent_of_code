defmodule ExAdvent.Y2021.Day24Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day24

  test "parse input" do
    input = ~s"""
    inp w
    add z w
    mod z 2
    div w 2
    add y w
    mod y 2
    div w 2
    add x w
    mod x 2
    div w 2
    mod w 2
    """

    assert parse_input(input) == [
             {"inp", "w", nil},
             {"add", "z", "w"},
             {"mod", "z", 2},
             {"div", "w", 2},
             {"add", "y", "w"},
             {"mod", "y", 2},
             {"div", "w", 2},
             {"add", "x", "w"},
             {"mod", "x", 2},
             {"div", "w", 2},
             {"mod", "w", 2}
           ]
  end

  test "execute_instruction -- input" do
    state = %{"w" => 0, "input" => [5, 1]}

    assert execute_instruction({"inp", "w", nil}, state) == [%{"w" => 5, "input" => [1]}]
  end

  test "execute_instruction -- add with value variable" do
    state = %{"w" => 5, "x" => 3}

    assert execute_instruction({"add", "x", "w"}, state) == [%{"w" => 5, "x" => 8}]
  end

  test "execute_instruction -- add with symbolic variable" do
    state = %{"w" => :a1, "x" => 3}

    assert execute_instruction({"add", "x", "w"}, state) == [%{"w" => :a1, "x" => {:+, 3, :a1}}]
  end

  test "execute_instruction -- add first value 0" do
    state = %{"w" => :a1, "x" => 0}

    assert execute_instruction({"add", "x", "w"}, state) == [%{"w" => :a1, "x" => :a1}]
  end

  test "execute_instruction -- add second value 0" do
    state = %{"w" => 0, "x" => :a1}

    assert execute_instruction({"add", "x", "w"}, state) == [%{"w" => 0, "x" => :a1}]
  end

  test "execute_instruction -- add with value" do
    state = %{"w" => 5, "x" => 3}

    assert execute_instruction({"add", "x", 15}, state) == [%{"w" => 5, "x" => 18}]
  end

  test "execute_instruction -- mul with value variable" do
    state = %{"w" => 5, "x" => 3}

    assert execute_instruction({"mul", "x", "w"}, state) == [%{"w" => 5, "x" => 15}]
  end

  test "execute_instruction -- mul with symbolic variable" do
    state = %{"w" => :a2, "x" => 3}

    assert execute_instruction({"mul", "x", "w"}, state) == [%{"w" => :a2, "x" => {:*, 3, :a2}}]
  end

  test "execute_instruction -- mul first value 0" do
    state = %{"w" => :a1, "x" => 0}

    assert execute_instruction({"mul", "x", "w"}, state) == [%{"w" => :a1, "x" => 0}]
  end

  test "execute_instruction -- mul second value 0" do
    state = %{"w" => 0, "x" => :a1}

    assert execute_instruction({"mul", "x", "w"}, state) == [%{"w" => 0, "x" => 0}]
  end

  test "execute_instruction -- mul with value" do
    state = %{"w" => 5, "x" => 3}

    assert execute_instruction({"mul", "x", 15}, state) == [%{"w" => 5, "x" => 45}]
  end

  test "execute_instruction -- div with value variable" do
    state = %{"w" => 35, "x" => 5}

    assert execute_instruction({"div", "w", "x"}, state) == [%{"w" => 7, "x" => 5}]
  end

  test "execute_instruction -- div with symbolic variable, divisor is greater than symbol" do
    state = %{"w" => :a2, "x" => 10}

    assert execute_instruction({"div", "w", "x"}, state) == [%{"w" => 0, "x" => 10}]
  end

  test "execute_instruction -- div with symbolic variable, divisor is less than symbol" do
    state = %{"w" => :a2, "x" => 5}

    assert execute_instruction({"div", "w", "x"}, state) == [%{"w" => {:/, :a2, 5}, "x" => 5}]
  end

  test "execute_instruction -- div with symbolic variable, divisor is one" do
    state = %{"w" => :a2, "x" => 1}

    assert execute_instruction({"div", "w", "x"}, state) == [%{"w" => :a2, "x" => 1}]
  end

  test "execute_instruction -- div with symbolic variable, last operation was a matching multiply" do
    state = %{"w" => {:*, 26, {:+, :a2, 11}}, "x" => 26}

    assert execute_instruction({"div", "w", "x"}, state) == [%{"w" => {:+, :a2, 11}, "x" => 26}]
  end

  test "execute_instruction -- div with symbolic variable, cute round down with addition thing" do
    state = %{"w" => {:+, {:*, 26, {:+, :a2, 11}}, {:+, :a1, 6}}, "x" => 26}

    assert execute_instruction({"div", "w", "x"}, state) == [%{"w" => {:+, :a2, 11}, "x" => 26}]
  end

  test "execute_instruction -- div with value" do
    state = %{"w" => 12, "x" => 3}

    assert execute_instruction({"div", "w", 4}, state) == [%{"w" => 3, "x" => 3}]
  end

  test "execute_instruction -- mod with symbolic variable, cute truncating multiples trick" do
    state = %{"w" => {:+, {:*, 26, {:+, :a2, 11}}, {:+, :a1, 6}}, "x" => 26}

    assert execute_instruction({"mod", "w", "x"}, state) == [%{"w" => {:+, :a1, 6}, "x" => 26}]
  end

  test "execute_instruction -- mod with var" do
    state = %{"w" => 9, "x" => 2}

    assert execute_instruction({"mod", "w", "x"}, state) == [%{"w" => 1, "x" => 2}]
  end

  test "execute_instruction -- mod with value" do
    state = %{"w" => 17, "x" => 3}

    assert execute_instruction({"mod", "w", 5}, state) == [%{"w" => 2, "x" => 3}]
  end

  test "execute_instruction -- eql with symbolic value" do
    state = %{"w" => {:+, :a1, 8}, "x" => 9, "conditionals" => []}

    assert execute_instruction({"eql", "w", "x"}, state) == [
             %{"conditionals" => [{:eq, {:+, :a1, 8}, 9}], "w" => 1, "x" => 9},
             %{"conditionals" => [{:neq, {:+, :a1, 8}, 9}], "w" => 0, "x" => 9}
           ]
  end

  test "execute_instruction -- eql with symbolic value, but over the possible value" do
    state = %{"w" => :a1, "x" => 10, "conditionals" => []}

    assert execute_instruction({"eql", "w", "x"}, state) == [
             %{"conditionals" => [], "w" => 0, "x" => 10}
           ]
  end

  test "execute_instruction -- eql with var" do
    state = %{"w" => 9, "x" => 9, "conditionals" => []}

    assert execute_instruction({"eql", "w", "x"}, state) == [%{"w" => 1, "x" => 9, "conditionals" => []}]
  end

  test "execute_instruction -- eql with value" do
    state = %{"w" => 5, "x" => 3, "conditionals" => []}

    assert execute_instruction({"eql", "w", 5}, state) == [%{"w" => 1, "x" => 3, "conditionals" => []}]
  end

  test "execute_instructions -- negating a number" do
    instructions = [{"inp", "x", nil}, {"mul", "x", -1}]
    input = [3]

    assert execute_instructions(instructions, input) == [
             %{"input" => [], "w" => 0, "x" => -3, "y" => 0, "z" => 0, "conditionals" => []}
           ]
  end

  test "execute_instructions -- three times larger" do
    input = ~s"""
    inp z
    inp x
    mul z 3
    eql z x
    """

    instructions = parse_input(input)
    input = [5, 15]

    assert execute_instructions(instructions, input) == [
             %{"conditionals" => [], "input" => [], "w" => 0, "x" => 15, "y" => 0, "z" => 1}
           ]
  end

  test "execute_instructions -- with symbols" do
    instructions = ~s"""
    inp w
    mul x 0
    add x z
    mod x 26
    div z 1
    add x 10
    eql x w
    eql x 0
    mul y 0
    add y 25
    mul y x
    add y 1
    mul z y
    mul y 0
    add y w
    add y 2
    mul y x
    add z y
    inp w
    mul x 0
    add x z
    mod x 26
    div z 1
    add x 10
    eql x w
    eql x 0
    mul y 0
    add y 25
    mul y x
    add y 1
    mul z y
    mul y 0
    add y w
    add y 4
    mul y x
    add z y
    """

    instructions = parse_input(instructions)
    input = [:a1, :a2]

    assert execute_instructions(instructions, input) == []
  end
end
