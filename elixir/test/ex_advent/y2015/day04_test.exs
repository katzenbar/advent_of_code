defmodule ExAdvent.Y2015.Day04Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day04

  test "find_hash_starting_with - abcdef gives 609043" do
    assert find_hash_starting_with("abcdef", "00000") == 609_043
  end

  test "find_hash_starting_with - pqrstuv gives 1048970" do
    assert find_hash_starting_with("pqrstuv", "00000") == 1_048_970
  end
end
