defmodule ExAdvent.Y2015.Day23Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day23

  test "parse input" do
    input = ~s"""
    inc a
    jio a, +2
    tpl b
    inc a
    jmp -4
    """

    assert parse_input(input) == [
             %{"instruction" => "inc", "offset" => "", "register" => "a"},
             %{"instruction" => "jio", "offset" => "+2", "register" => "a"},
             %{"instruction" => "tpl", "offset" => "", "register" => "b"},
             %{"instruction" => "inc", "offset" => "", "register" => "a"},
             %{"instruction" => "jmp", "offset" => "-4", "register" => ""}
           ]
  end

  test "execute_program" do
    machine = %{
      "a" => 0,
      "b" => 0,
      "execution_pointer" => 0,
      "instructions" => [
        %{"instruction" => "inc", "offset" => "", "register" => "a"},
        %{"instruction" => "jio", "offset" => "+2", "register" => "a"},
        %{"instruction" => "tpl", "offset" => "", "register" => "b"},
        %{"instruction" => "inc", "offset" => "", "register" => "a"}
      ]
    }

    expected = %{
      "a" => 2,
      "b" => 0,
      "execution_pointer" => 4,
      "instructions" => [
        %{"instruction" => "inc", "offset" => "", "register" => "a"},
        %{"instruction" => "jio", "offset" => "+2", "register" => "a"},
        %{"instruction" => "tpl", "offset" => "", "register" => "b"},
        %{"instruction" => "inc", "offset" => "", "register" => "a"}
      ]
    }

    assert execute_program(machine) == expected
  end

  test "execute_instruction - hlf" do
    machine = %{"a" => 2, "b" => 8, "execution_pointer" => 3}

    result =
      execute_instruction(%{"instruction" => "hlf", "offset" => "", "register" => "b"}, machine)

    expected = %{"a" => 2, "b" => 4, "execution_pointer" => 4}

    assert result == expected
  end

  test "execute_instruction - inc" do
    machine = %{"a" => 2, "b" => 8, "execution_pointer" => 3}

    result =
      execute_instruction(%{"instruction" => "inc", "offset" => "", "register" => "a"}, machine)

    expected = %{"a" => 3, "b" => 8, "execution_pointer" => 4}

    assert result == expected
  end

  test "execute_instruction - tpl" do
    machine = %{"a" => 2, "b" => 3, "execution_pointer" => 5}

    result =
      execute_instruction(%{"instruction" => "tpl", "offset" => "", "register" => "b"}, machine)

    expected = %{"a" => 2, "b" => 9, "execution_pointer" => 6}

    assert result == expected
  end

  test "execute_instruction - jmp pos" do
    machine = %{"a" => 2, "b" => 3, "execution_pointer" => 5}

    result =
      execute_instruction(%{"instruction" => "jmp", "offset" => "+2", "register" => ""}, machine)

    expected = %{"a" => 2, "b" => 3, "execution_pointer" => 7}

    assert result == expected
  end

  test "execute_instruction - jmp neg" do
    machine = %{"a" => 2, "b" => 3, "execution_pointer" => 5}

    result =
      execute_instruction(%{"instruction" => "jmp", "offset" => "-3", "register" => ""}, machine)

    expected = %{"a" => 2, "b" => 3, "execution_pointer" => 2}

    assert result == expected
  end

  test "execute_instruction - jie even" do
    machine = %{"a" => 2, "b" => 3, "execution_pointer" => 5}

    result =
      execute_instruction(%{"instruction" => "jie", "offset" => "-3", "register" => "a"}, machine)

    expected = %{"a" => 2, "b" => 3, "execution_pointer" => 2}

    assert result == expected
  end

  test "execute_instruction - jie odd" do
    machine = %{"a" => 5, "b" => 3, "execution_pointer" => 5}

    result =
      execute_instruction(%{"instruction" => "jie", "offset" => "-3", "register" => "a"}, machine)

    expected = %{"a" => 5, "b" => 3, "execution_pointer" => 6}

    assert result == expected
  end

  test "execute_instruction - jio one" do
    machine = %{"a" => 2, "b" => 1, "execution_pointer" => 5}

    result =
      execute_instruction(%{"instruction" => "jio", "offset" => "-3", "register" => "b"}, machine)

    expected = %{"a" => 2, "b" => 1, "execution_pointer" => 2}

    assert result == expected
  end

  test "execute_instruction - jio not 1" do
    machine = %{"a" => 5, "b" => 3, "execution_pointer" => 5}

    result =
      execute_instruction(%{"instruction" => "jio", "offset" => "-3", "register" => "b"}, machine)

    expected = %{"a" => 5, "b" => 3, "execution_pointer" => 6}

    assert result == expected
  end
end
