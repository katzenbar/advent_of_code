defmodule ExAdvent.Y2015.Day16Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day16

  test "detected_attributes" do
    assert detected_attributes() == %{
             "akitas" => 0,
             "cars" => 2,
             "cats" => 7,
             "children" => 3,
             "goldfish" => 5,
             "perfumes" => 1,
             "pomeranians" => 3,
             "samoyeds" => 2,
             "trees" => 3,
             "vizslas" => 0
           }
  end

  test "parse_sue - Sue 1" do
    input_line = "Sue 1: children: 1, cars: 8, vizslas: 7"
    expected_result = {"1", [["children", 1], ["cars", 8], ["vizslas", 7]]}

    assert parse_sue(input_line) == expected_result
  end

  test "matching_sue? - single match" do
    assert matching_sue?({"2", [["akitas", 0]]}, detected_attributes()) == true
  end

  test "matching_sue? - single failure" do
    assert matching_sue?({"2", [["akitas", 1]]}, detected_attributes()) == false
  end

  test "matching_sue? - both match" do
    assert matching_sue?({"2", [["goldfish", 5], ["pomeranians", 3]]}, detected_attributes()) ==
             true
  end

  test "matching_sue? - some match" do
    assert matching_sue?({"2", [["trees", 2], ["perfumes", 1]]}, detected_attributes()) ==
             false
  end

  test "attribute_matches? - regular attribute matching" do
    assert attribute_matches?("cars", 2, %{"cars" => 2}) == true
  end

  test "attribute_matches? - regular attribute different" do
    assert attribute_matches?("cars", 3, %{"cars" => 2}) == false
  end

  test "attribute_matches? - cats less than" do
    assert attribute_matches?("cats", 1, %{"cats" => 2}) == false
  end

  test "attribute_matches? - cats equal" do
    assert attribute_matches?("cats", 2, %{"cats" => 2}) == false
  end

  test "attribute_matches? - cats more than" do
    assert attribute_matches?("cats", 3, %{"cats" => 2}) == true
  end

  test "attribute_matches? - goldfish less than" do
    assert attribute_matches?("goldfish", 1, %{"goldfish" => 2}) == true
  end

  test "attribute_matches? - goldfish equal" do
    assert attribute_matches?("goldfish", 2, %{"goldfish" => 2}) == false
  end

  test "attribute_matches? - goldfish more than" do
    assert attribute_matches?("goldfish", 3, %{"goldfish" => 2}) == false
  end
end
