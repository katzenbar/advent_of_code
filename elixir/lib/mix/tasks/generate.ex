defmodule Mix.Tasks.Generate do
  @moduledoc "Generates basic files for advent of code solutions, use `mix generate 2016 1`"
  @shortdoc "Generates basic files for advent of code solutions"

  use Mix.Task

  @impl Mix.Task
  def run([year, day]) do
    app_dir = File.cwd!()
    padded_day = String.pad_leading(day, 2, "0")

    Mix.shell().info("Creating files for Advent of Code year #{year}, day #{padded_day}")

    # -- Input ------------------------------------------------------------------------------------
    inputs_year_path = Path.join([app_dir, "inputs", "y#{year}"])
    input_path = Path.join([inputs_year_path, "day#{padded_day}"])

    case File.exists?(input_path) do
      true ->
        Mix.shell().info("Input already exists")

      false ->
        File.mkdir_p!(inputs_year_path)
        File.write!(input_path, "", [:write])
        Mix.shell().info("Input created: #{input_path}")
    end

    # -- Year module ------------------------------------------------------------------------------
    module_path = Path.join([app_dir, "lib", "ex_advent", "y#{year}.ex"])

    case File.exists?(input_path) do
      false ->
        File.write!(
          input_path,
          ~s"""
          defmodule ExAdvent.Y#{year} do
          end
          """,
          [:write]
        )

        Mix.shell().info("Module created: #{module_path}")

      _ ->
        nil
    end

    # -- Solution file ----------------------------------------------------------------------------
    solution_folder_path = Path.join([app_dir, "lib", "ex_advent", "y#{year}"])
    solution_path = Path.join([solution_folder_path, "day#{padded_day}.ex"])

    case File.exists?(solution_path) do
      true ->
        Mix.shell().info("Solution already exists")

      false ->
        File.mkdir_p!(solution_folder_path)

        File.write!(
          solution_path,
          ~s"""
          defmodule ExAdvent.Y#{year}.Day#{padded_day} do
            def solve_part1 do
              input()
              |> parse_input()
              |> IO.puts()
            end

            def solve_part2 do
              input()
              |> parse_input()
              |> IO.puts()
            end

            def input do
              File.read!("inputs/y#{year}/day#{padded_day}")
            end

            def parse_input(input) do
              input
              |> String.trim()
              |> String.split("\\n")
            end
          end
          """,
          [:write]
        )

        Mix.shell().info("Solution created: #{solution_path}")
    end

    # -- Test file --------------------------------------------------------------------------------
    test_folder_path = Path.join([app_dir, "test", "ex_advent", "y#{year}"])
    test_path = Path.join([test_folder_path, "day#{padded_day}_test.exs"])

    case File.exists?(test_path) do
      true ->
        Mix.shell().info("Test already exists")

      false ->
        File.mkdir_p!(test_folder_path)

        File.write!(
          test_path,
          ~s"""
          defmodule ExAdvent.Y#{year}.Day#{padded_day}Test do
            use ExUnit.Case

            import ExAdvent.Y#{year}.Day#{padded_day}

              def sample_input() do
                ~s\"""
                \"""
              end

              def parsed_sample_input() do
                parse_input(sample_input())
              end

              test "parse input" do
                assert parsed_sample_input() == ""
              end
          end
          """,
          [:write]
        )

        Mix.shell().info("Test created: #{test_path}")
    end
  end
end
