defmodule ExAdvent.Y2015.Day10Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day10

  test "build_chunks - 1211" do
    assert build_chunks('1211') == ['1', '2', '11']
  end

  test "build_chunks - 312211" do
    assert build_chunks('312211') == ['3', '1', '22', '11']
  end

  test "say_chunks - 1" do
    assert say_chunks(['1']) == '11'
  end

  test "say_chunks - 21" do
    assert say_chunks(['2', '1']) == '1211'
  end

  test "look_and_say - 1" do
    assert look_and_say('1') == '11'
  end

  test "look_and_say - 21" do
    assert look_and_say('21') == '1211'
  end

  test "look_and_say - 1211" do
    assert look_and_say('1211') == '111221'
  end

  test "look_and_say - 111221" do
    assert look_and_say('111221') == '312211'
  end
end
