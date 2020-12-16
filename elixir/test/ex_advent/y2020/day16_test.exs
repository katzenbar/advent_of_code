defmodule ExAdvent.Y2020.Day16Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day16

  test "parse input" do
    input = ~s"""
    class: 1-3 or 5-7
    row: 6-11 or 33-44
    seat: 13-40 or 45-50

    your ticket:
    7,1,14

    nearby tickets:
    7,3,47
    40,4,50
    55,2,20
    38,6,12
    """

    assert parse_input(input) == %{
             fields: [{"class", 1..3, 5..7}, {"row", 6..11, 33..44}, {"seat", 13..40, 45..50}],
             mine: [7, 1, 14],
             nearby: [[7, 3, 47], [40, 4, 50], [55, 2, 20], [38, 6, 12]]
           }
  end

  test "parse_input pt2" do
    input = ~s"""
    class: 0-1 or 4-19
    row: 0-5 or 8-19
    seat: 0-13 or 16-19

    your ticket:
    11,12,13

    nearby tickets:
    3,9,18
    15,1,5
    5,14,9
    """

    assert parse_input(input) == %{
             fields: [{"class", 0..1, 4..19}, {"row", 0..5, 8..19}, {"seat", 0..13, 16..19}],
             mine: [11, 12, 13],
             nearby: [[3, 9, 18], [15, 1, 5], [5, 14, 9]]
           }
  end

  test "nearby_ticket_scanning_error_rate" do
    state = %{
      fields: [{"class", 1..3, 5..7}, {"row", 6..11, 33..44}, {"seat", 13..40, 45..50}],
      mine: [7, 1, 14],
      nearby: [[7, 3, 47], [40, 4, 50], [55, 2, 20], [38, 6, 12]]
    }

    assert nearby_ticket_scanning_error_rate(state) == 71
  end

  test "valid_nearby_tickets" do
    state = %{
      fields: [{"class", 1..3, 5..7}, {"row", 6..11, 33..44}, {"seat", 13..40, 45..50}],
      mine: [7, 1, 14],
      nearby: [[7, 3, 47], [40, 4, 50], [55, 2, 20], [38, 6, 12]]
    }

    assert valid_nearby_tickets(state) == [[7, 3, 47]]
  end

  test "find_field_positions" do
    state = %{
      fields: [{"class", 0..1, 4..19}, {"row", 0..5, 8..19}, {"seat", 0..13, 16..19}],
      mine: [11, 12, 13],
      nearby: [[3, 9, 18], [15, 1, 5], [5, 14, 9]]
    }

    assert find_field_positions(state) == [
             {"row", 0..5, 8..19},
             {"class", 0..1, 4..19},
             {"seat", 0..13, 16..19}
           ]
  end

  test "find_departure_values" do
    state = %{
      fields: [
        {"class", 0..1, 4..19},
        {"departure location", 0..5, 8..19},
        {"departure time", 0..13, 16..19}
      ],
      mine: [11, 12, 13],
      nearby: [[3, 9, 18], [15, 1, 5], [5, 14, 9]]
    }

    assert find_departure_values(state) == [11, 13]
  end
end
