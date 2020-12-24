defmodule ExAdvent.Y2020.Day24Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day24

  test "parse input" do
    assert example_input() == [
             [:se, :se, :nw, :ne, :ne, :ne, :w, :se, :e, :sw, :w, :sw, :sw, :w, :ne, :ne, :w, :se, :w, :sw],
             [:ne, :e, :e, :ne, :se, :nw, :nw, :w, :sw, :ne, :ne, :w, :nw, :w, :se, :w, :ne, :nw, :se, :sw, :e, :sw],
             [:se, :sw, :ne, :sw, :sw, :se, :nw, :w, :nw, :se],
             [:nw, :nw, :ne, :se, :e, :sw, :sw, :ne, :ne, :w, :ne, :sw, :w, :ne, :w, :se, :sw, :ne, :se, :e, :ne],
             [:sw, :w, :e, :sw, :ne, :sw, :ne, :nw, :se, :w, :nw, :ne, :ne, :se, :e, :nw],
             [:e, :e, :se, :nw, :se, :sw, :sw, :ne, :nw, :sw, :nw, :nw, :se, :w, :w, :nw, :se, :ne],
             [:se, :w, :ne, :ne, :ne, :ne, :se, :nw, :se, :w, :ne, :nw, :w, :w, :se],
             [:w, :e, :nw, :w, :w, :e, :se, :e, :e, :w, :e, :sw, :w, :w, :nw, :w, :e],
             [:w, :sw, :e, :e, :se, :ne, :ne, :w, :nw, :w, :nw, :se, :ne, :w, :se, :nw, :w, :se, :se, :se, :nw, :ne],
             [:ne, :e, :sw, :se, :e, :nw, :w, :sw, :nw, :sw, :sw, :nw],
             [:ne, :nw, :sw, :w, :se, :w, :sw, :ne, :ne, :ne, :w, :se, :nw, :se, :nw, :ne, :se, :se, :ne, :w],
             [:e, :ne, :w, :nw, :e, :w, :ne, :sw, :se, :w, :nw, :sw, :e, :nw, :e, :sw, :ne, :nw, :se, :nw, :sw],
             [:sw, :e, :ne, :sw, :ne, :sw, :ne, :ne, :e, :nw, :ne, :w, :e, :ne, :w, :w, :ne, :sw, :sw, :ne, :se],
             [:sw, :w, :e, :se, :ne, :se, :w, :e, :nw, :ne, :sw, :nw, :w, :ne, :se, :sw, :w, :ne],
             [:e, :ne, :se, :nw, :sw, :w, :sw, :ne, :ne, :sw, :se, :nw, :ne, :w, :sw, :se, :e, :nw, :se, :se],
             [:w, :nw, :ne, :se, :ne, :se, :ne, :nw, :w, :ne, :nw, :se, :w, :e, :se, :w, :se, :se, :se, :w],
             [:ne, :ne, :w, :sw, :nw, :e, :w, :sw, :ne, :ne, :se, :nw, :ne, :se, :w, :e, :sw],
             [:e, :ne, :sw, :nw, :sw, :nw, :se, :ne, :nw, :nw, :nw, :w, :se, :e, :sw, :ne, :e, :w, :se, :ne, :se],
             [:ne, :sw, :nw, :e, :w, :nw, :nw, :se, :e, :nw, :se, :e, :se, :w, :se, :nw, :sw, :e, :e, :w, :e],
             [:w, :se, :w, :e, :e, :e, :nw, :ne, :se, :nw, :w, :w, :sw, :ne, :w]
           ]
  end

  test "parse_line" do
    assert parse_line("nwwswee") == [:nw, :w, :sw, :e, :e]
  end

  test "get_tile_coordinates - e" do
    assert get_tile_coordinates([:e]) == {1, -1, 0}
  end

  test "get_tile_coordinates - w" do
    assert get_tile_coordinates([:w]) == {-1, 1, 0}
  end

  test "get_tile_coordinates - ne" do
    assert get_tile_coordinates([:ne]) == {1, 0, -1}
  end

  test "get_tile_coordinates - sw" do
    assert get_tile_coordinates([:sw]) == {-1, 0, 1}
  end

  test "get_tile_coordinates - nw" do
    assert get_tile_coordinates([:nw]) == {0, 1, -1}
  end

  test "get_tile_coordinates - se" do
    assert get_tile_coordinates([:se]) == {0, -1, 1}
  end

  test "get_tile_coordinates - esew" do
    assert get_tile_coordinates([:e, :se, :w]) == {0, -1, 1}
  end

  test "get_tile_coordinates - nwwswee" do
    assert get_tile_coordinates([:nw, :w, :sw, :e, :e]) == {0, 0, 0}
  end

  test "flip_tiles_for_directions" do
    assert flip_tiles_for_directions(example_input()) |> MapSet.size() == 10
  end

  test "flip_tiles_for_days" do
    assert flip_tiles_for_days(example_input(), 100) |> MapSet.size() == 2208
  end

  def example_input do
    input = ~s"""
    sesenwnenenewseeswwswswwnenewsewsw
    neeenesenwnwwswnenewnwwsewnenwseswesw
    seswneswswsenwwnwse
    nwnwneseeswswnenewneswwnewseswneseene
    swweswneswnenwsewnwneneseenw
    eesenwseswswnenwswnwnwsewwnwsene
    sewnenenenesenwsewnenwwwse
    wenwwweseeeweswwwnwwe
    wsweesenenewnwwnwsenewsenwwsesesenwne
    neeswseenwwswnwswswnw
    nenwswwsewswnenenewsenwsenwnesesenew
    enewnwewneswsewnwswenweswnenwsenwsw
    sweneswneswneneenwnewenewwneswswnese
    swwesenesewenwneswnwwneseswwne
    enesenwswwswneneswsenwnewswseenwsese
    wnwnesenesenenwwnenwsewesewsesesew
    nenewswnwewswnenesenwnesewesw
    eneswnwswnwsenenwnwnwwseeswneewsenese
    neswnwewnwnwseenwseesewsenwsweewe
    wseweeenwnesenwwwswnew
    """

    parse_input(input)
  end
end
