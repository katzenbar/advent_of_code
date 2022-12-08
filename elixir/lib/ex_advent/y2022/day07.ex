defmodule ExAdvent.Y2022.Day07 do
  def solve_part1 do
    input()
    |> parse_input()
    |> get_sum_of_dirs_under_size(100_000)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> get_dir_to_delete()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2022/day07")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("$", trim: true)
    |> Enum.map(fn x ->
      x
      |> String.trim()
      |> String.split("\n", trim: true)
      |> parse_command()
    end)
  end

  def parse_command(["cd " <> rest]) do
    {:cd, rest}
  end

  def parse_command(["ls" | rest]) do
    {:ls, Enum.map(rest, &parse_files_and_dirs/1)}
  end

  def parse_files_and_dirs("dir " <> rest), do: {:dir, rest}

  def parse_files_and_dirs(str) do
    [size_str, filename] = String.split(str, " ")
    size = String.to_integer(size_str)
    {:file, filename, size}
  end

  def build_file_tree(input) do
    {_, dirs} = Enum.reduce(input, {[], %{}}, &execute_command/2)

    dirs
  end

  def execute_command({:cd, "/"}, {_, dir_map}), do: {["/"], dir_map}
  def execute_command({:cd, ".."}, {[_ | parent_dirs], dir_map}), do: {parent_dirs, dir_map}
  def execute_command({:cd, dir}, {current_dirs, dir_map}), do: {[dir | current_dirs], dir_map}

  def execute_command({:ls, files}, {current_dirs, dir_map}) do
    dir_str =
      current_dirs
      |> Enum.reverse()
      |> Enum.join("/")
      |> String.replace("//", "/")

    dir_map =
      Enum.reduce(files, dir_map, fn file, dir_map ->
        Map.update(dir_map, dir_str, [file], fn v -> [file | v] end)
      end)

    {current_dirs, dir_map}
  end

  def get_directory_sizes(file_tree) do
    Map.keys(file_tree)
    |> Enum.reduce(%{}, fn dir, size_cache ->
      size = get_dir_size(dir, file_tree)
      Map.put(size_cache, dir, size)
    end)
  end

  defp get_dir_size(dir, file_tree) do
    Map.get(file_tree, dir)
    |> Enum.reduce(0, fn file_or_dir, size ->
      case file_or_dir do
        {:dir, dirname} ->
          dirsize = get_dir_size(String.replace(dir <> "/" <> dirname, "//", "/"), file_tree)
          size + dirsize

        {:file, _, filesize} ->
          size + filesize
      end
    end)
  end

  def get_sum_of_dirs_under_size(input, max_size) do
    input
    |> build_file_tree()
    |> get_directory_sizes()
    |> Map.values()
    |> Enum.filter(fn x -> x <= max_size end)
    |> Enum.sum()
  end

  def get_dir_to_delete(input) do
    dir_sizes =
      input
      |> build_file_tree()
      |> get_directory_sizes()

    disk_used = Map.get(dir_sizes, "/")
    free_space = 70_000_000 - disk_used
    additional_space_needed = 30_000_000 - free_space

    dir_sizes
    |> Map.values()
    |> Enum.filter(fn size -> size >= additional_space_needed end)
    |> Enum.min()
  end
end
