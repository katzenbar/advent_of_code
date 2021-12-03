defmodule ExAdvent.Util.CircleZipperTest do
  use ExUnit.Case

  import ExAdvent.Util.CircleZipper

  test "current_value" do
    zipper = {[], 1, []}
    assert current_value(zipper) == 1
  end

  test "insert - both sides empty" do
    zipper = {[], 1, []}
    assert insert(zipper, 2) == {[1], 2, []}
  end

  test "insert - right side empty" do
    zipper = {[1], 2, []}
    assert insert(zipper, 3) == {[2, 1], 3, []}
  end

  test "insert - left side empty" do
    zipper = {[], 2, [4]}
    assert insert(zipper, 3) == {[2], 3, [4]}
  end

  test "insert - both sides full" do
    zipper = {[1], 2, [4, 5]}
    assert insert(zipper, 3) == {[2, 1], 3, [4, 5]}
  end

  test "remove - both sides empty" do
    assert_raise ArgumentError, fn ->
      remove({[], 1, []})
    end
  end

  test "remove - left side empty" do
    zipper = {[], 1, [2, 3]}
    assert remove(zipper) == {[], 2, [3]}
  end

  test "remove - right side empty" do
    zipper = {[3, 2, 1], 4, []}
    assert remove(zipper) == {[], 1, [2, 3]}
  end

  test "remove - both sides full" do
    zipper = {[3, 2, 1], 4, [5, 6, 7]}
    assert remove(zipper) == {[3, 2, 1], 5, [6, 7]}
  end

  test "rotate_cw - both sides empty" do
    zipper = {[], 1, []}
    assert rotate_cw(zipper) == {[], 1, []}
  end

  test "rotate_cw - left side empty" do
    zipper = {[], 1, [2, 3]}
    assert rotate_cw(zipper) == {[1], 2, [3]}
  end

  test "rotate_cw - right side empty" do
    zipper = {[2, 3], 1, []}
    assert rotate_cw(zipper) == {[1], 3, [2]}
  end

  test "rotate_cw - both sides full" do
    zipper = {[3, 2, 1], 4, [5, 6, 7]}
    assert rotate_cw(zipper) == {[4, 3, 2, 1], 5, [6, 7]}
  end

  test "rotate_ccw - both sides empty" do
    zipper = {[], 1, []}
    assert rotate_ccw(zipper) == {[], 1, []}
  end

  test "rotate_ccw - left side empty" do
    zipper = {[], 1, [2, 3, 4]}
    assert rotate_ccw(zipper) == {[3, 2], 4, [1]}
  end

  test "rotate_ccw - right side empty" do
    zipper = {[2, 3, 4], 1, []}
    assert rotate_ccw(zipper) == {[3, 4], 2, [1]}
  end

  test "rotate_ccw - both sides full" do
    zipper = {[3, 2, 1], 4, [5, 6, 7]}
    assert rotate_ccw(zipper) == {[2, 1], 3, [4, 5, 6, 7]}
  end

  test "to_list" do
    zipper = {[3, 2, 1], 4, [5, 6, 7]}
    assert to_list(zipper) == [1, 2, 3, 4, 5, 6, 7]
  end
end
