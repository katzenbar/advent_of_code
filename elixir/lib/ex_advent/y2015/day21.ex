defmodule ExAdvent.Y2015.Day21 do
  def solve_part1 do
    input()
    |> parse_input()
    |> best_weapon_build()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> worst_weapon_build()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2015/day21")
  end

  def parse_input(input) do
    Regex.scan(~r/\d+/, String.trim(input))
    |> Enum.map(fn [x] -> String.to_integer(x) end)
    |> List.to_tuple()
  end

  def best_weapon_build(boss) do
    item_combinations()
    |> Stream.filter(fn {_cost, dmg, def} ->
      player_wins_battle?({100, dmg, def}, boss)
    end)
    |> Stream.take(1)
    |> Enum.to_list()
    |> List.first()
    |> elem(0)
  end

  def worst_weapon_build(boss) do
    item_combinations()
    |> Enum.reverse()
    |> Stream.filter(fn {_cost, dmg, def} ->
      !player_wins_battle?({100, dmg, def}, boss)
    end)
    |> Stream.take(1)
    |> Enum.to_list()
    |> List.first()
    |> elem(0)
  end

  def player_wins_battle?(player, boss) do
    final_state =
      {:player, player, boss}
      |> Stream.iterate(&simulate_battle_turn/1)
      |> Stream.filter(fn {_, {player_hp, _, _}, {boss_hp, _, _}} ->
        player_hp <= 0 || boss_hp <= 0
      end)
      |> Stream.take(1)
      |> Enum.to_list()
      |> List.first()

    # If its the boss's turn next, then the player did damage last and brought the boss to 0
    elem(final_state, 0) == :boss
  end

  def simulate_battle_turn({:player, player, boss}) do
    {:boss, player, apply_attack(player, boss)}
  end

  def simulate_battle_turn({:boss, player, boss}) do
    {:player, apply_attack(boss, player), boss}
  end

  def apply_attack({_, attacker_dmg, _}, {defender_hp, defender_dmg, defender_def}) do
    dmg = Enum.max([1, attacker_dmg - defender_def])

    {defender_hp - dmg, defender_dmg, defender_def}
  end

  # Weapons:    Cost  Damage  Armor
  # Dagger        8     4       0
  # Shortsword   10     5       0
  # Warhammer    25     6       0
  # Longsword    40     7       0
  # Greataxe     74     8       0

  # Armor:      Cost  Damage  Armor
  # Leather      13     0       1
  # Chainmail    31     0       2
  # Splintmail   53     0       3
  # Bandedmail   75     0       4
  # Platemail   102     0       5

  # Rings:      Cost  Damage  Armor
  # Damage +1    25     1       0
  # Damage +2    50     2       0
  # Damage +3   100     3       0
  # Defense +1   20     0       1
  # Defense +2   40     0       2
  # Defense +3   80     0       3

  def item_combinations do
    weapons = [
      {8, 4, 0},
      {10, 5, 0},
      {25, 6, 0},
      {40, 7, 0},
      {74, 8, 0}
    ]

    armor = [
      {0, 0, 0},
      {13, 0, 1},
      {31, 0, 2},
      {53, 0, 3},
      {75, 0, 4},
      {102, 0, 5}
    ]

    rings = [
      {25, 1, 0},
      {50, 2, 0},
      {100, 3, 0},
      {20, 0, 1},
      {40, 0, 2},
      {80, 0, 3}
    ]

    Enum.flat_map(weapons, fn w ->
      Enum.flat_map(armor, fn a ->
        Enum.map(pick_up_to(rings, 2), fn rs ->
          [w | [a | rs]]
        end)
      end)
    end)
    |> Enum.map(fn items ->
      Enum.reduce(items, {0, 0, 0}, fn {i_cost, i_dmg, i_def}, {t_cost, t_dmg, t_def} ->
        {i_cost + t_cost, i_dmg + t_dmg, i_def + t_def}
      end)
    end)
    |> Enum.sort_by(fn {cost, _, _} -> cost end)
  end

  def pick_up_to(items, max_picks) do
    0..(trunc(:math.pow(2, Enum.count(items))) - 1)
    |> Stream.map(&Integer.digits(&1, 2))
    |> Stream.filter(fn digits -> Enum.sum(digits) <= max_picks end)
    |> Stream.map(&pad_left(&1, Enum.count(items), 0))
    |> Stream.map(&Enum.zip(&1, items))
    |> Stream.map(fn digits ->
      Enum.reduce(digits, [], fn {mask, value}, acc ->
        case mask do
          1 -> [value | acc]
          _ -> acc
        end
      end)
    end)
    |> Enum.to_list()
  end

  def pad_left(list, length, padding_value) do
    num_digits_to_add = length - Enum.count(list)

    cond do
      num_digits_to_add > 0 ->
        1..num_digits_to_add
        |> Enum.reduce(list, fn _, acc -> List.insert_at(acc, 0, padding_value) end)

      true ->
        list
    end
  end
end
