defmodule ExAdvent.Y2020.Day04Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day04

  test "parse input" do
    input = ~s"""
    ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
    byr:1937 iyr:2017 cid:147 hgt:183cm

    iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
    hcl:#cfa07d byr:1929

    hcl:#ae17e1 iyr:2013
    eyr:2024
    ecl:brn pid:760753108 byr:1931
    hgt:179cm

    hcl:#cfa07d eyr:2025 pid:166559648
    iyr:2011 ecl:brn hgt:59in
    """

    assert parse_input(input) == [
             [
               {"ecl", "gry"},
               {"pid", "860033327"},
               {"eyr", "2020"},
               {"hcl", "#fffffd"},
               {"byr", "1937"},
               {"iyr", "2017"},
               {"cid", "147"},
               {"hgt", "183cm"}
             ],
             [
               {"iyr", "2013"},
               {"ecl", "amb"},
               {"cid", "350"},
               {"eyr", "2023"},
               {"pid", "028048884"},
               {"hcl", "#cfa07d"},
               {"byr", "1929"}
             ],
             [
               {"hcl", "#ae17e1"},
               {"iyr", "2013"},
               {"eyr", "2024"},
               {"ecl", "brn"},
               {"pid", "760753108"},
               {"byr", "1931"},
               {"hgt", "179cm"}
             ],
             [
               {"hcl", "#cfa07d"},
               {"eyr", "2025"},
               {"pid", "166559648"},
               {"iyr", "2011"},
               {"ecl", "brn"},
               {"hgt", "59in"}
             ]
           ]
  end

  test "passport_has_all_required_fields? - a passport with all fields" do
    passport = [
      {"ecl", "gry"},
      {"pid", "860033327"},
      {"eyr", "2020"},
      {"hcl", "#fffffd"},
      {"byr", "1937"},
      {"iyr", "2017"},
      {"cid", "147"},
      {"hgt", "183cm"}
    ]

    assert passport_has_all_required_fields?(passport) == true
  end

  test "passport_has_all_required_fields? - a passport with missing fields" do
    passport = [
      {"hcl", "#cfa07d"},
      {"eyr", "2025"},
      {"pid", "166559648"},
      {"iyr", "2011"},
      {"ecl", "brn"},
      {"hgt", "59in"}
    ]

    assert passport_has_all_required_fields?(passport) == false
  end

  test "passport_has_all_required_fields? - a passport with missing cid only" do
    passport = [
      {"hcl", "#ae17e1"},
      {"iyr", "2013"},
      {"eyr", "2024"},
      {"ecl", "brn"},
      {"pid", "760753108"},
      {"byr", "1931"},
      {"hgt", "179cm"}
    ]

    assert passport_has_all_required_fields?(passport) == true
  end

  test "passport_field_valid? - cid" do
    assert passport_field_valid?({"cid", "asdf"}) == true
  end

  test "passport_field_valid? - byr not a number" do
    assert passport_field_valid?({"byr", "asdf"}) == false
  end

  test "passport_field_valid? - byr less than 1920" do
    assert passport_field_valid?({"byr", "1919"}) == false
  end

  test "passport_field_valid? - byr between 1920 and 2002" do
    assert passport_field_valid?({"byr", "1999"}) == true
  end

  test "passport_field_valid? - byr more than 2002" do
    assert passport_field_valid?({"byr", "2003"}) == false
  end

  test "passport_field_valid? - hgt only a number" do
    assert passport_field_valid?({"hgt", "2003"}) == false
  end

  test "passport_field_valid? - hgt no number" do
    assert passport_field_valid?({"hgt", "asdf"}) == false
  end

  test "passport_field_valid? - hgt in under 59" do
    assert passport_field_valid?({"hgt", "58in"}) == false
  end

  test "passport_field_valid? - hgt in between 59 and 76" do
    assert passport_field_valid?({"hgt", "59in"}) == true
  end

  test "passport_field_valid? - hgt in over 76" do
    assert passport_field_valid?({"hgt", "77in"}) == false
  end

  test "passport_field_valid? - hgt cm under 150" do
    assert passport_field_valid?({"hgt", "149cm"}) == false
  end

  test "passport_field_valid? - hgt cm between 150 and 193" do
    assert passport_field_valid?({"hgt", "193cm"}) == true
  end

  test "passport_field_valid? - hgt cm over 193" do
    assert passport_field_valid?({"hgt", "194cm"}) == false
  end

  test "passport_field_valid? - hcl no hashtag" do
    assert passport_field_valid?({"hcl", "123abc"}) == false
  end

  test "passport_field_valid? - hcl not enough digits" do
    assert passport_field_valid?({"hcl", "#123bc"}) == false
  end

  test "passport_field_valid? - hcl too many digits" do
    assert passport_field_valid?({"hcl", "#123abcd"}) == false
  end

  test "passport_field_valid? - hcl match" do
    assert passport_field_valid?({"hcl", "#123abc"}) == true
  end

  test "passport_field_valid? - ecl not in set" do
    assert passport_field_valid?({"ecl", "blk"}) == false
  end

  test "passport_field_valid? - ecl in set" do
    assert passport_field_valid?({"ecl", "amb"}) == true
  end

  test "passport_field_valid? - pid not nine digits" do
    assert passport_field_valid?({"pid", "01234567"}) == false
  end

  test "passport_field_valid? - pid nine digits" do
    assert passport_field_valid?({"pid", "012345678"}) == true
  end

  test "passport_field_valid? - pid ten digits" do
    assert passport_field_valid?({"pid", "0123456789"}) == false
  end
end
