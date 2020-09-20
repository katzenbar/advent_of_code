defmodule ExAdvent.Y2015.Day02Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day02

  test "2x3x4 requires 58 square feet of wrapping paper" do
    assert sqft_paper_required("2x3x4") == 58
  end

  test "1x1x10 requires 43 square feet of wrapping paper" do
    assert sqft_paper_required("1x1x10") == 43
  end

  test "2x3x4 requires 34 feet of ribbon" do
    assert length_ribbon_required("2x3x4") == 34
  end

  test "1x1x10 requires 14 feet of ribbon" do
    assert length_ribbon_required("1x1x10") == 14
  end
end
