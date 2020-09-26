defmodule ExAdvent.Y2015.Day11Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day11

  test "increment_string - aaaaaaaa" do
    assert increment_string("aaaaaaaa") == "aaaaaaab"
  end

  test "increment_string - aaaaaaab" do
    assert increment_string("aaaaaaab") == "aaaaaaac"
  end

  test "increment_string - aaaaaaaz" do
    assert increment_string("aaaaaaaz") == "aaaaaaba"
  end

  test "increment_string - aazzzzzz" do
    assert increment_string("aazzzzzz") == "abaaaaaa"
  end

  test "increment_string - zzzzzzzz" do
    assert increment_string("zzzzzzzz") == "aaaaaaaa"
  end

  test "has_straight? - hiiklomn" do
    assert has_straight?("hiiklomn") == false
  end

  test "has_straight? - hijklmmn" do
    assert has_straight?("hijklmmn") == true
  end

  test "has_no_ambiguous_characters? - hijkxmmn" do
    assert has_no_ambiguous_characters?("hijkxmmn") == false
  end

  test "has_no_ambiguous_characters? - hljkxmmn" do
    assert has_no_ambiguous_characters?("hljkxmmn") == false
  end

  test "has_no_ambiguous_characters? - hojkxmmn" do
    assert has_no_ambiguous_characters?("hojkxmmn") == false
  end

  test "has_no_ambiguous_characters? - hxjkxmmn" do
    assert has_no_ambiguous_characters?("hxjkxmmn") == true
  end

  test "contains_two_pairs? - aaa" do
    assert contains_two_pairs?("aaa") == false
  end

  test "contains_two_pairs? - aaaa" do
    assert contains_two_pairs?("aaaa") == true
  end

  test "contains_two_pairs? - aabaa" do
    assert contains_two_pairs?("aabaa") == true
  end

  test "contains_two_pairs? - baabaab" do
    assert contains_two_pairs?("baabaab") == true
  end

  test "next_password - abcdefgh" do
    assert next_password("abcdefgh") == "abcdffaa"
  end

  test "next_password - ghijklmn" do
    assert next_password("ghijklmn") == "ghjaabcc"
  end
end
