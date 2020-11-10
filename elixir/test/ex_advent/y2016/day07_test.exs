defmodule ExAdvent.Y2016.Day07Test do
  use ExUnit.Case

  import ExAdvent.Y2016.Day07

  test "parse input" do
    input = ~s"""
    abba[mnop]qrst
    asdf[bddb]xyyx
    aaaa[qwer]tyui
    """

    assert parse_input(input) == [
             "abba[mnop]qrst",
             "asdf[bddb]xyyx",
             "aaaa[qwer]tyui"
           ]
  end

  test "main_sequences" do
    input = "abba[mnop]qr[qwer]st"
    assert main_sequences(input) == ["abba", "qr", "st"]
  end

  test "hypernet_sequences" do
    input = "abba[mnop]qr[qwer]st"
    assert hypernet_sequences(input) == ["mnop", "qwer"]
  end

  test "has_abba? - abba" do
    assert has_abba?("abba") == true
  end

  test "has_abba? - dddd" do
    assert has_abba?("dddd") == false
  end

  test "has_abba? - asffeeffs" do
    assert has_abba?("asffeeffs") == true
  end

  test "supports_tls? - abba[mnop]qrst" do
    assert supports_tls?("abba[mnop]qrst") == true
  end

  test "supports_tls? - asdf[bddb]xyyx" do
    assert supports_tls?("asdf[bddb]xyyx") == false
  end

  test "get_abas - single" do
    assert get_abas("bdba") == [{"b", "d"}]
  end

  test "get_abas - loose combo" do
    assert get_abas("zazbz") == [{"z", "a"}, {"z", "b"}]
  end

  test "get_abas - tight combo" do
    assert get_abas("zaza") == [{"z", "a"}, {"a", "z"}]
  end

  test "has_babs?" do
    assert has_babs?("bab", [{"a", "b"}]) == true
  end

  test "supports_ssl? - aba[bab]xyz" do
    assert supports_ssl?("aba[bab]xyz") == true
  end

  test "supports_ssl? - xyx[xyx]xyx" do
    assert supports_ssl?("xyx[xyx]xyx") == false
  end

  test "supports_ssl? - aaa[kek]eke" do
    assert supports_ssl?("aaa[kek]eke") == true
  end

  test "supports_ssl? - zazbz[bzb]cdb" do
    assert supports_ssl?("zazbz[bzb]cdb") == true
  end
end
