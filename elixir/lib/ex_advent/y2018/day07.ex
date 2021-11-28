defmodule ExAdvent.Y2018.Day07 do
  def solve_part1 do
    input()
    |> parse_input()
    |> get_instruction_order()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> simulate_construction(5, 60)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2018/day07")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def parse_line(input_line) do
    result =
      Regex.named_captures(
        ~r/Step (?<depends_on>.+) must be finished before step (?<target>.+) can begin\./,
        input_line
      )

    {result["depends_on"], result["target"]}
  end

  def build_dependency_graph(dependencies) do
    dependencies
    |> Enum.reduce(%{}, fn {depends_on, target}, acc ->
      acc
      |> Map.put_new(target, MapSet.new())
      |> Map.put_new(depends_on, MapSet.new())
      |> Map.update!(target, &MapSet.put(&1, depends_on))
    end)
  end

  @spec get_instruction_order(any) :: binary
  def get_instruction_order(dependencies) do
    dependency_graph = build_dependency_graph(dependencies)

    Stream.unfold(
      {MapSet.new(), dependency_graph},
      fn
        {_, dependency_graph} when dependency_graph == %{} ->
          nil

        {completed_steps, dependency_graph} ->
          next_step = get_next_step(dependency_graph, completed_steps)

          completed_steps = MapSet.put(completed_steps, next_step)
          dependency_graph = Map.delete(dependency_graph, next_step)

          {next_step, {completed_steps, dependency_graph}}
      end
    )
    |> Enum.join()
  end

  def get_next_step(dependency_graph, completed_steps) do
    dependency_graph
    |> Map.to_list()
    |> Enum.filter(fn {_, dependencies} -> MapSet.subset?(dependencies, completed_steps) end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sort()
    |> List.first()
  end

  def simulate_construction(dependencies, num_workers, base_task_length) do
    dependency_graph = build_dependency_graph(dependencies)

    Stream.unfold(
      {-1, [], MapSet.new(), dependency_graph},
      fn
        {_, [], _, dependency_graph} when dependency_graph == %{} ->
          nil

        {current_time, worker_assignments, completed_steps, dependency_graph} ->
          current_time = current_time + 1

          # Remove completed work assignments, add them to our set of completed steps
          {completed_work, uncompleted_work} =
            Enum.split_with(worker_assignments, fn {_, completion_time} -> completion_time <= current_time end)

          newly_completed_steps = Enum.map(completed_work, &elem(&1, 0))
          completed_steps = MapSet.union(completed_steps, MapSet.new(newly_completed_steps))

          worker_assignments = uncompleted_work

          # Add new work
          next_construction_state =
            get_next_construction_state(
              {current_time, worker_assignments, completed_steps, dependency_graph},
              num_workers,
              base_task_length
            )

          {current_time, next_construction_state}
      end
    )
    |> Enum.to_list()
    |> List.last()
  end

  def get_next_construction_state(
        {current_time, worker_assignments, completed_steps, dependency_graph},
        num_workers,
        base_task_length
      ) do
    next_step = get_next_step(dependency_graph, completed_steps)

    cond do
      next_step == nil ->
        {current_time, worker_assignments, completed_steps, dependency_graph}

      length(worker_assignments) >= num_workers ->
        {current_time, worker_assignments, completed_steps, dependency_graph}

      true ->
        assignment = {next_step, task_length(next_step, base_task_length) + current_time}

        worker_assignments = [assignment | worker_assignments]
        dependency_graph = Map.delete(dependency_graph, next_step)

        get_next_construction_state(
          {current_time, worker_assignments, completed_steps, dependency_graph},
          num_workers,
          base_task_length
        )
    end
  end

  def task_length(step, base_task_length) do
    (step |> String.to_charlist() |> List.first()) - ?A + 1 + base_task_length
  end
end
