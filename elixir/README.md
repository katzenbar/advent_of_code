# ExAdvent

Solutions for Advent of Code written in Elixir.

## Generate Files

To generate files for a new day, use

```bash
mix generate 2016 1
```

Where 2016 is the year and 1 is the day.

## Tests

To run all tests, use

```bash
mix test
```

To run tests for a certain day, use

```bash
mix test test/ex_advent/y2015/day01_test.exs
```

## Solve

To solve puzzles, run the solve method for the corresponding day and part

```bash
mix run -e "ExAdvent.Y2015.Day01.solve_part1"
```
