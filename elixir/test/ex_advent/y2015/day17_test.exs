defmodule ExAdvent.Y2015.Day17Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day17

  test "combine_containers" do
    containers = [5, 6, 7]

    assert combine_containers(containers) == [[7], [6], [6, 7], [5], [5, 7], [5, 6], [5, 6, 7]]
  end

  test "containers_to_store_exact_amount" do
    containers = [20, 15, 10, 5, 5]

    assert containers_to_store_exact_amount(containers, 25) == [
             [15, 5, 5],
             [15, 10],
             [20, 5],
             [20, 5]
           ]
  end
end
