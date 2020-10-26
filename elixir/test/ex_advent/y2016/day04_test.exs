defmodule ExAdvent.Y2016.Day04Test do
  use ExUnit.Case

  import ExAdvent.Y2016.Day04

  test "parse input" do
    input = ~s"""
    aaaaa-bbb-z-y-x-123[abxyz]
    a-b-c-d-e-f-g-h-987[abcde]
    not-a-real-room-404[oarel]
    totally-real-room-200[decoy]
    """

    assert parse_input(input) == [
             {"aaaaa-bbb-z-y-x", 123, "abxyz"},
             {"a-b-c-d-e-f-g-h", 987, "abcde"},
             {"not-a-real-room", 404, "oarel"},
             {"totally-real-room", 200, "decoy"}
           ]
  end

  test "is_real_room? - aaaaa-bbb-z-y-x-123[abxyz]" do
    room = {"aaaaa-bbb-z-y-x", 123, "abxyz"}
    assert is_real_room?(room) == true
  end

  test "is_real_room? - not-a-real-room-404[oarel]" do
    room = {"not-a-real-room", 404, "oarel"}
    assert is_real_room?(room) == true
  end

  test "is_real_room? - totally-real-room-200[decoy]" do
    room = {"totally-real-room", 200, "decoy"}

    assert is_real_room?(room) == false
  end

  test "decrypt_name - qzmt-zixmtkozy-ivhz-343" do
    assert decrypt_name("qzmt-zixmtkozy-ivhz", 343) == "very encrypted name"
  end
end
