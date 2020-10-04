defmodule ExAdvent.Y2015.Day19Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day19

  test "parse_input" do
    input = ~s"""
    H => HO
    H => OH
    O => HH

    HOH
    """

    assert parse_input(input) == {"HOH", [["H", "HO"], ["H", "OH"], ["O", "HH"]]}
  end

  test "molecule_to_element_list - all caps" do
    assert molecule_to_element_list("HOH") == ["H", "O", "H"]
  end

  test "molecule_to_element_list - two letter elements" do
    assert molecule_to_element_list("RnSiRnMg") == ["Rn", "Si", "Rn", "Mg"]
  end

  test "molecule_to_element_list - mixed" do
    assert molecule_to_element_list("RnHRnHH") == ["Rn", "H", "Rn", "H", "H"]
  end

  test "possible_replacements - sample" do
    assert possible_replacements({"HOH", [["H", "HO"], ["H", "OH"], ["O", "HH"]]}) == [
             "HOHO",
             "HOOH",
             "OHOH",
             "HHHH"
           ]
  end

  test "replacements_in_molecule - one replacement" do
    assert replacements_in_molecule("HOH", ["H", "HO"]) == ["HH"]
  end

  test "replacements_in_molecule many replacements" do
    assert replacements_in_molecule("HOHOHO", ["H", "HO"]) == ["HOHOH", "HOHHO", "HHOHO"]
  end

  test "possible_reverse_replacements - sample" do
    assert possible_reverse_replacements(
             {"HOH", [["H", "HO"], ["H", "OH"], ["O", "HH"], ["e", "H"], ["e", "O"]]}
           ) == ["HH", "HOe", "eOH", "HeH"]
  end

  test "steps_to_generate_molecule - HOH sample" do
    assert steps_to_generate_molecule(
             {"HOH", [["H", "HO"], ["H", "OH"], ["O", "HH"], ["e", "H"], ["e", "O"]]}
           ) == 3
  end

  test "steps_to_generate_molecule - HOHOHO sample" do
    assert steps_to_generate_molecule(
             {"HOHOHO", [["H", "HO"], ["H", "OH"], ["O", "HH"], ["e", "H"], ["e", "O"]]}
           ) == 6
  end
end
