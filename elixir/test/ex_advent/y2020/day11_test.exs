defmodule ExAdvent.Y2020.Day11Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day11

  test "parse input" do
    input = ~s"""
    L.LL.LL.LL
    LLLLLLL.LL
    L.L.L..L..
    LLLL.LL.LL
    L.LL.LL.LL
    L.LLLLL.LL
    ..L.L.....
    LLLLLLLLLL
    L.LLLLLL.L
    L.LLLLL.LL
    """

    assert parse_input(input) == [
             'L.LL.LL.LL',
             'LLLLLLL.LL',
             'L.L.L..L..',
             'LLLL.LL.LL',
             'L.LL.LL.LL',
             'L.LLLLL.LL',
             '..L.L.....',
             'LLLLLLLLLL',
             'L.LLLLLL.L',
             'L.LLLLL.LL'
           ]
  end

  test "get_adjacent_seats - top left" do
    seat_map = [
      'L.L',
      'LLL',
      'L.L'
    ]

    assert get_adjacent_seats(seat_map, 0, 0) == '......LL'
  end

  test "get_adjacent_seats - center" do
    seat_map = [
      'L.L',
      'LLL',
      'L.L'
    ]

    assert get_adjacent_seats(seat_map, 1, 1) == 'L.LLLL.L'
  end

  test "get_adjacent_seats - bottom right" do
    seat_map = [
      'L.L',
      'LLL',
      'L.L'
    ]

    assert get_adjacent_seats(seat_map, 2, 2) == 'LL......'
  end

  test "get_next_seat_pt1 - floor" do
    assert get_next_seat_pt1(?., []) == ?.
  end

  test "get_next_seat_pt1 - empty seat with no occupied seats adjacent" do
    assert get_next_seat_pt1(?L, '..L..LLL') == ?#
  end

  test "get_next_seat_pt1 - empty seat with one occupied seats adjacent" do
    assert get_next_seat_pt1(?L, '..L..L#L') == ?L
  end

  test "get_next_seat_pt1 - occupied seat with no occupied seats adjacent" do
    assert get_next_seat_pt1(?#, '..L..LLL') == ?#
  end

  test "get_next_seat_pt1 - occupied seat with three occupied seats adjacent" do
    assert get_next_seat_pt1(?#, '..L..###') == ?#
  end

  test "get_next_seat_pt1 - occupied seat with four occupied seats adjacent" do
    assert get_next_seat_pt1(?#, '..#..###') == ?L
  end

  test "apply_rules_once_pt1 - round 1" do
    seat_map = [
      'L.LL.LL.LL',
      'LLLLLLL.LL',
      'L.L.L..L..',
      'LLLL.LL.LL',
      'L.LL.LL.LL',
      'L.LLLLL.LL',
      '..L.L.....',
      'LLLLLLLLLL',
      'L.LLLLLL.L',
      'L.LLLLL.LL'
    ]

    expected = [
      '#.##.##.##',
      '#######.##',
      '#.#.#..#..',
      '####.##.##',
      '#.##.##.##',
      '#.#####.##',
      '..#.#.....',
      '##########',
      '#.######.#',
      '#.#####.##'
    ]

    assert apply_rules_once_pt1(seat_map) == expected
  end

  test "apply_rules_once_pt1 - round 2" do
    seat_map = [
      '#.##.##.##',
      '#######.##',
      '#.#.#..#..',
      '####.##.##',
      '#.##.##.##',
      '#.#####.##',
      '..#.#.....',
      '##########',
      '#.######.#',
      '#.#####.##'
    ]

    expected = [
      '#.LL.L#.##',
      '#LLLLLL.L#',
      'L.L.L..L..',
      '#LLL.LL.L#',
      '#.LL.LL.LL',
      '#.LLLL#.##',
      '..L.L.....',
      '#LLLLLLLL#',
      '#.LLLLLL.L',
      '#.#LLLL.##'
    ]

    assert apply_rules_once_pt1(seat_map) == expected
  end

  test "apply_rules_pt1" do
    seat_map = [
      'L.LL.LL.LL',
      'LLLLLLL.LL',
      'L.L.L..L..',
      'LLLL.LL.LL',
      'L.LL.LL.LL',
      'L.LLLLL.LL',
      '..L.L.....',
      'LLLLLLLLLL',
      'L.LLLLLL.L',
      'L.LLLLL.LL'
    ]

    expected = [
      '#.#L.L#.##',
      '#LLL#LL.L#',
      'L.#.L..#..',
      '#L##.##.L#',
      '#.#L.LL.LL',
      '#.#L#L#.##',
      '..L.L.....',
      '#L#L##L#L#',
      '#.LLLLLL.L',
      '#.#L#L#.##'
    ]

    assert apply_rules_pt1(seat_map) == expected
  end

  test "get_visible_seats - all full" do
    input = ~s"""
    .......#.
    ...#.....
    .#.......
    .........
    ..#L....#
    ....#....
    .........
    #........
    ...#.....
    """

    seat_map = parse_input(input)

    assert get_visible_seats(seat_map, 4, 3) == '########'
  end

  test "apply_rules_pt2" do
    seat_map =
      ~s"""
      L.LL.LL.LL
      LLLLLLL.LL
      L.L.L..L..
      LLLL.LL.LL
      L.LL.LL.LL
      L.LLLLL.LL
      ..L.L.....
      LLLLLLLLLL
      L.LLLLLL.L
      L.LLLLL.LL
      """
      |> parse_input()

    expected =
      ~s"""
      #.L#.L#.L#
      #LLLLLL.LL
      L.L.L..#..
      ##L#.#L.L#
      L.L#.LL.L#
      #.LLLL#.LL
      ..#.L.....
      LLL###LLL#
      #.LLLLL#.L
      #.L#LL#.L#
      """
      |> parse_input()

    assert apply_rules_pt2(seat_map) == expected
  end
end
