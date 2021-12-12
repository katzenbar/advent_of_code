defmodule ExAdvent.Y2021.Day12Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day12

  test "parse input" do
    input = ~s"""
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
    """

    assert parse_input(input) == %{
             "A" => ["end", "b", "c", "start"],
             "b" => ["end", "d", "A", "start"],
             "start" => ["b", "A"],
             "c" => ["A"],
             "d" => ["b"],
             "end" => ["b", "A"]
           }
  end

  test "find_all_paths - visit small caves once - first example" do
    input = ~s"""
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
    """

    paths_map = parse_input(input)

    assert find_all_paths(paths_map, 1) == [
             ["start", "b", "end"],
             ["start", "b", "A", "end"],
             ["start", "b", "A", "c", "A", "end"],
             ["start", "A", "end"],
             ["start", "A", "b", "end"],
             ["start", "A", "b", "A", "end"],
             ["start", "A", "b", "A", "c", "A", "end"],
             ["start", "A", "c", "A", "end"],
             ["start", "A", "c", "A", "b", "end"],
             ["start", "A", "c", "A", "b", "A", "end"]
           ]
  end

  test "find_all_paths - visit small cave twice - first example" do
    input = ~s"""
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
    """

    paths_map = parse_input(input)

    assert find_all_paths(paths_map, 2) |> length() == 36
  end

  test "find_all_paths - visit small caves once - second example" do
    input = ~s"""
    dc-end
    HN-start
    start-kj
    dc-start
    dc-HN
    LN-dc
    HN-end
    kj-sa
    kj-HN
    kj-dc
    """

    paths_map = parse_input(input)

    assert find_all_paths(paths_map, 1) == [
             ["start", "dc", "kj", "HN", "end"],
             ["start", "dc", "HN", "kj", "HN", "end"],
             ["start", "dc", "HN", "end"],
             ["start", "dc", "end"],
             ["start", "kj", "dc", "HN", "end"],
             ["start", "kj", "dc", "end"],
             ["start", "kj", "HN", "end"],
             ["start", "kj", "HN", "dc", "HN", "end"],
             ["start", "kj", "HN", "dc", "end"],
             ["start", "HN", "kj", "dc", "HN", "end"],
             ["start", "HN", "kj", "dc", "end"],
             ["start", "HN", "kj", "HN", "end"],
             ["start", "HN", "kj", "HN", "dc", "HN", "end"],
             ["start", "HN", "kj", "HN", "dc", "end"],
             ["start", "HN", "end"],
             ["start", "HN", "dc", "kj", "HN", "end"],
             ["start", "HN", "dc", "HN", "kj", "HN", "end"],
             ["start", "HN", "dc", "HN", "end"],
             ["start", "HN", "dc", "end"]
           ]
  end

  test "find_all_paths - visit small cave twice - second example" do
    input = ~s"""
    dc-end
    HN-start
    start-kj
    dc-start
    dc-HN
    LN-dc
    HN-end
    kj-sa
    kj-HN
    kj-dc
    """

    paths_map = parse_input(input)

    assert find_all_paths(paths_map, 2) |> length() == 103
  end

  test "find_all_paths - visit small caves once - third example" do
    input = ~s"""
    fs-end
    he-DX
    fs-he
    start-DX
    pj-DX
    end-zg
    zg-sl
    zg-pj
    pj-he
    RW-he
    fs-DX
    pj-RW
    zg-RW
    start-pj
    he-WI
    zg-he
    pj-fs
    start-RW
    """

    paths_map = parse_input(input)

    assert find_all_paths(paths_map, 1) |> length() == 226
  end

  test "find_all_paths - visit small cave twice - third example" do
    input = ~s"""
    fs-end
    he-DX
    fs-he
    start-DX
    pj-DX
    end-zg
    zg-sl
    zg-pj
    pj-he
    RW-he
    fs-DX
    pj-RW
    zg-RW
    start-pj
    he-WI
    zg-he
    pj-fs
    start-RW
    """

    paths_map = parse_input(input)

    assert find_all_paths(paths_map, 2) |> length() == 3509
  end
end
