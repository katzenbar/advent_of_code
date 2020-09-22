defmodule ExAdvent.Y2015.Day05Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day05

  test "part1_nice_string? - aeei is nice" do
    assert part1_nice_string?("aeei") == true
  end

  test "part1_nice_string? - xazzegov is nice" do
    assert part1_nice_string?("xazzegov") == true
  end

  test "part1_nice_string? - aeiouaeiouaeeiou is nice" do
    assert part1_nice_string?("aeiouaeiouaeeiou") == true
  end

  test "part1_nice_string? - aaebbccedde is nice" do
    assert part1_nice_string?("aaebbccedde") == true
  end

  test "part1_nice_string? - ugknbfddgicrmopn is nice" do
    assert part1_nice_string?("ugknbfddgicrmopn") == true
  end

  test "part1_nice_string? - aaa is nice" do
    assert part1_nice_string?("aaa") == true
  end

  test "part1_nice_string? - jchzalrnumimnmhp is naughty" do
    assert part1_nice_string?("jchzalrnumimnmhp") == false
  end

  test "part1_nice_string? - haegwjzuvuyypxyu is naughty" do
    assert part1_nice_string?("haegwjzuvuyypxyu") == false
  end

  test "part1_nice_string? - dvszwmarrgswjxmb is naughty" do
    assert part1_nice_string?("dvszwmarrgswjxmb") == false
  end

  test "contains_repeating_pair? - aaa" do
    assert contains_repeating_pair?("aaa") == false
  end

  test "contains_repeating_pair? - xyxy" do
    assert contains_repeating_pair?("xyxy") == true
  end

  test "contains_repeating_pair? - aabcdefgaa" do
    assert contains_repeating_pair?("aabcdefgaa") == true
  end

  test "contains_repeat_sandwich? - xyx" do
    assert contains_repeat_sandwich?("xyx") == true
  end

  test "contains_repeat_sandwich? - aaa" do
    assert contains_repeat_sandwich?("aaa") == true
  end

  test "part2_nice_string? - qjhvhtzxzqqjkmpb is nice" do
    assert part2_nice_string?("qjhvhtzxzqqjkmpb") == true
  end

  test "part2_nice_string? - xxyxx is nice" do
    assert part2_nice_string?("xxyxx") == true
  end

  test "part2_nice_string? - uurcxstgmygtbstg is naughty" do
    assert part2_nice_string?("uurcxstgmygtbstg") == false
  end

  test "part2_nice_string? - ieodomkazucvgmuy is naughty" do
    assert part2_nice_string?("ieodomkazucvgmuy") == false
  end
end
