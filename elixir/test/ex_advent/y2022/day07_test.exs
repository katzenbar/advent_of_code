defmodule ExAdvent.Y2022.Day07Test do
  use ExUnit.Case

  import ExAdvent.Y2022.Day07

  def sample_input() do
    ~s"""
    $ cd /
    $ ls
    dir a
    14848514 b.txt
    8504156 c.dat
    dir d
    $ cd a
    $ ls
    dir e
    29116 f
    2557 g
    62596 h.lst
    $ cd e
    $ ls
    584 i
    $ cd ..
    $ cd ..
    $ cd d
    $ ls
    4060174 j
    8033020 d.log
    5626152 d.ext
    7214296 k
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() == [
             cd: "/",
             ls: [{:dir, "a"}, {:file, "b.txt", 14_848_514}, {:file, "c.dat", 8_504_156}, {:dir, "d"}],
             cd: "a",
             ls: [{:dir, "e"}, {:file, "f", 29116}, {:file, "g", 2557}, {:file, "h.lst", 62596}],
             cd: "e",
             ls: [{:file, "i", 584}],
             cd: "..",
             cd: "..",
             cd: "d",
             ls: [
               {:file, "j", 4_060_174},
               {:file, "d.log", 8_033_020},
               {:file, "d.ext", 5_626_152},
               {:file, "k", 7_214_296}
             ]
           ]
  end

  test "build_file_tree" do
    assert build_file_tree(parsed_sample_input()) == %{
             "/" => [{:dir, "d"}, {:file, "c.dat", 8_504_156}, {:file, "b.txt", 14_848_514}, {:dir, "a"}],
             "/a" => [{:file, "h.lst", 62596}, {:file, "g", 2557}, {:file, "f", 29116}, {:dir, "e"}],
             "/a/e" => [{:file, "i", 584}],
             "/d" => [
               {:file, "k", 7_214_296},
               {:file, "d.ext", 5_626_152},
               {:file, "d.log", 8_033_020},
               {:file, "j", 4_060_174}
             ]
           }
  end

  test "get_directory_sizes" do
    assert get_directory_sizes(build_file_tree(parsed_sample_input())) == %{
             "/" => 48_381_165,
             "/a" => 94853,
             "/a/e" => 584,
             "/d" => 24_933_642
           }
  end

  test "get_sum_of_dirs_under_size" do
    assert get_sum_of_dirs_under_size(parsed_sample_input(), 100_000) == 95437
  end

  test "get_dir_to_delete" do
    assert get_dir_to_delete(parsed_sample_input()) == 24_933_642
  end
end
