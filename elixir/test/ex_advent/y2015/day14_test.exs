defmodule ExAdvent.Y2015.Day14Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day14

  # Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
  # Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.

  test "distance_after - Comet 1s" do
    deer = {14, 10, 127}
    assert distance_after(deer, 1) == 14
  end

  test "distance_after - Comet 10s" do
    deer = {14, 10, 127}
    assert distance_after(deer, 10) == 140
  end

  test "distance_after - Comet 11s" do
    deer = {14, 10, 127}
    assert distance_after(deer, 11) == 140
  end

  test "distance_after - Comet 1000s" do
    deer = {14, 10, 127}
    assert distance_after(deer, 1000) == 1120
  end

  test "score_second - after 1s" do
    deer_scores = %{{14, 10, 127} => 0, {16, 11, 162} => 0}
    assert score_second(1, deer_scores) == %{{14, 10, 127} => 0, {16, 11, 162} => 1}
  end

  test "score_race - after 1s" do
    deers = [{14, 10, 127}, {16, 11, 162}]
    assert score_race(deers, 1) == %{{14, 10, 127} => 0, {16, 11, 162} => 1}
  end

  test "score_race - after 140s" do
    deers = [{14, 10, 127}, {16, 11, 162}]
    assert score_race(deers, 140) == %{{14, 10, 127} => 1, {16, 11, 162} => 139}
  end

  test "score_race - after 1000s" do
    deers = [{14, 10, 127}, {16, 11, 162}]
    assert score_race(deers, 1000) == %{{14, 10, 127} => 312, {16, 11, 162} => 689}
  end
end
