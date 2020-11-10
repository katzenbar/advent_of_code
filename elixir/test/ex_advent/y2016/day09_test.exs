defmodule ExAdvent.Y2016.Day09Test do
  use ExUnit.Case

  import ExAdvent.Y2016.Day09

  test "decompress_once - ADVENT" do
    assert decompress_once("ADVENT") == "ADVENT"
  end

  test "decompress_once - A(1x5)BC" do
    assert decompress_once("A(1x5)BC") == "ABBBBBC"
  end

  test "decompress_once - (3x3)XYZ" do
    assert decompress_once("(3x3)XYZ") == "XYZXYZXYZ"
  end

  test "decompress_once - A(2x2)BCD(2x2)EFG" do
    assert decompress_once("A(2x2)BCD(2x2)EFG") == "ABCBCDEFEFG"
  end

  test "decompress_once - X(8x2)(3x3)ABCY" do
    assert decompress_once("X(8x2)(3x3)ABCY") == "X(3x3)ABC(3x3)ABCY"
  end

  test "count_deep_decompressed_chars - X(8x2)(3x3)ABCY" do
    assert count_deep_decompressed_chars("X(8x2)(3x3)ABCY") == 20
  end

  test "count_deep_decompressed_chars - (25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN" do
    assert count_deep_decompressed_chars(
             "(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN"
           ) == 445
  end

  test "count_deep_decompressed_chars - (27x12)(20x12)(13x14)(7x10)(1x12)A" do
    assert count_deep_decompressed_chars("(27x12)(20x12)(13x14)(7x10)(1x12)A") == 241_920
  end

  test "decompress_next_marker - A(1x5)BC" do
    assert decompress_next_marker("A(1x5)BC") == {"A", "BBBBB", "C"}
  end
end
