defmodule ExAdvent.Y2021.Day04Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day04

  def sample_input do
    ~s"""
    7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

    22 13 17 11  0
    8  2 23  4 24
    21  9 14 16  7
    6 10  3 18  5
    1 12 20 15 19

    3 15  0  2 22
    9 18 13 17  5
    19  8  7 25 23
    20 11 10 24  4
    14 21 16 12  6

    14 21 17 24  4
    10 16 15  9 19
    18  8 23 26 20
    22 11 13  6  5
     2  0 12  3  7
    """
  end

  test "parse input" do
    assert parse_input(sample_input()) ==
             {
               [7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24, 10, 16, 13, 6, 15, 25, 12, 22, 18, 20, 8, 19, 3, 26, 1],
               [
                 [
                   [22, 13, 17, 11, 0],
                   [8, 2, 23, 4, 24],
                   [21, 9, 14, 16, 7],
                   [6, 10, 3, 18, 5],
                   [1, 12, 20, 15, 19]
                 ],
                 [
                   [3, 15, 0, 2, 22],
                   [9, 18, 13, 17, 5],
                   [19, 8, 7, 25, 23],
                   [20, 11, 10, 24, 4],
                   [14, 21, 16, 12, 6]
                 ],
                 [
                   [14, 21, 17, 24, 4],
                   [10, 16, 15, 9, 19],
                   [18, 8, 23, 26, 20],
                   [22, 11, 13, 6, 5],
                   [2, 0, 12, 3, 7]
                 ]
               ]
             }
  end

  test "find_first_winning_board" do
    game = parse_input(sample_input())

    assert find_first_winning_board(game) ==
             {
               [24, 21, 14, 0, 2, 23, 17, 11, 5, 9, 4, 7],
               [
                 [14, 21, 17, 24, 4],
                 [10, 16, 15, 9, 19],
                 [18, 8, 23, 26, 20],
                 [22, 11, 13, 6, 5],
                 [2, 0, 12, 3, 7]
               ]
             }
  end

  test "find_winning_boards - one before winning" do
    {_, boards} = parse_input(sample_input())
    boards_with_sets = build_winning_sets_for_boards(boards)

    assert find_winning_boards([7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21], boards_with_sets) == []
  end

  test "find_winning_boards - one boards wins" do
    {_, boards} = parse_input(sample_input())
    boards_with_sets = build_winning_sets_for_boards(boards)

    assert find_winning_boards([7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24], boards_with_sets) == [
             [
               [14, 21, 17, 24, 4],
               [10, 16, 15, 9, 19],
               [18, 8, 23, 26, 20],
               [22, 11, 13, 6, 5],
               [2, 0, 12, 3, 7]
             ]
           ]
  end

  test "score_board" do
    drawn_numbers = [24, 21, 14, 0, 2, 23, 17, 11, 5, 9, 4, 7]

    board = [
      [14, 21, 17, 24, 4],
      [10, 16, 15, 9, 19],
      [18, 8, 23, 26, 20],
      [22, 11, 13, 6, 5],
      [2, 0, 12, 3, 7]
    ]

    assert score_board(drawn_numbers, board) == 4512
  end

  test "get_first_winning_score" do
    game = parse_input(sample_input())
    assert get_first_winning_score(game) == 4512
  end

  test "find_last_winning_board" do
    game = parse_input(sample_input())

    assert find_last_winning_board(game) ==
             {
               [13, 16, 10, 24, 21, 14, 0, 2, 23, 17, 11, 5, 9, 4, 7],
               [
                 [3, 15, 0, 2, 22],
                 [9, 18, 13, 17, 5],
                 [19, 8, 7, 25, 23],
                 [20, 11, 10, 24, 4],
                 [14, 21, 16, 12, 6]
               ]
             }
  end

  test "find_last_winning_score" do
    game = parse_input(sample_input())
    assert get_last_winning_score(game) == 1924
  end
end
