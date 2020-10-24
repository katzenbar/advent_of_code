defmodule ExAdvent.Y2015.Day22 do
  def solve_part1 do
    input()
    |> parse_input()
    |> get_initial_game_states()
    |> simulate_turns(:player, :easy)
    |> Map.get(:mana_spent)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> get_initial_game_states()
    |> simulate_turns(:player, :hard)
    |> Map.get(:mana_spent)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2015/day22")
  end

  def parse_input(input) do
    Regex.scan(~r/\d+/, String.trim(input))
    |> Enum.map(fn [x] -> String.to_integer(x) end)
    |> List.to_tuple()
  end

  def get_initial_game_states({boss_hp, boss_dmg}) do
    [
      %{
        mana_spent: 0,
        player: %{hp: 50, armor: 0, mana: 500, shield: 0, recharge: 0},
        boss: %{hp: boss_hp, dmg: boss_dmg, poison: 0}
      }
    ]
  end

  def simulate_turns(game_states, attacker, mode \\ :easy) do
    won_game_states =
      Enum.filter(game_states, &won_game_state?/1) |> Enum.sort_by(&Map.get(&1, :mana_spent))

    cond do
      Enum.count(won_game_states) > 0 ->
        Enum.at(won_game_states, 0)

      true ->
        simulate_turn(game_states, attacker, mode)
        |> simulate_turns(next_attacker(attacker), mode)
    end
  end

  def next_attacker(:player) do
    :boss
  end

  def next_attacker(:boss) do
    :player
  end

  def simulate_turn(game_states, attacker, mode \\ :easy)

  def simulate_turn(game_states, :player, mode) do
    Enum.flat_map(
      [:magic_missile, :drain, :shield, :poison, :recharge],
      fn spell ->
        Enum.map(game_states, &simulate_action(&1, spell))
      end
    )
    |> Enum.map(fn game_state ->
      case mode do
        :hard ->
          Map.update!(game_state, :player, fn player ->
            Map.update!(player, :hp, fn hp -> hp - 1 end)
          end)

        :easy ->
          game_state
      end
    end)
    |> Enum.filter(&valid_game_state?/1)
  end

  def simulate_turn(game_states, :boss, _mode) do
    Enum.flat_map(
      [:boss_attack],
      fn spell ->
        Enum.map(game_states, &simulate_action(&1, spell))
      end
    )
    |> Enum.filter(&valid_game_state?/1)
  end

  def valid_game_state?(%{player: player}) do
    Map.get(player, :hp) > 0 && Map.get(player, :mana) > 0
  end

  def won_game_state?(%{boss: boss}) do
    Map.get(boss, :hp) <= 0
  end

  def simulate_action(game_state, spell) do
    game_state = apply_effects(game_state)

    case boss_defeated?(game_state) do
      true ->
        game_state

      false ->
        apply_spell(spell, game_state)
    end
  end

  def boss_defeated?(%{boss: boss}) do
    Map.get(boss, :hp) == 0
  end

  def apply_effects(%{mana_spent: mana_spent, player: player, boss: boss}) do
    shield = Map.get(player, :shield)
    recharge = Map.get(player, :recharge)
    poison = Map.get(boss, :poison)

    player =
      case shield do
        0 -> player
        1 -> player |> Map.update!(:armor, fn _ -> 0 end) |> Map.update!(:shield, fn _ -> 0 end)
        _ -> Map.update!(player, :shield, fn s -> s - 1 end)
      end

    player =
      case recharge do
        0 ->
          player

        _ ->
          player
          |> Map.update!(:mana, fn m -> m + 101 end)
          |> Map.update!(:recharge, fn r -> r - 1 end)
      end

    boss =
      case poison do
        0 ->
          boss

        _ ->
          boss |> Map.update!(:hp, fn hp -> hp - 3 end) |> Map.update!(:poison, fn p -> p - 1 end)
      end

    %{mana_spent: mana_spent, player: player, boss: boss}
  end

  # Magic Missile costs 53 mana. It instantly does 4 damage.
  def apply_spell(:magic_missile, %{mana_spent: mana_spent, player: player, boss: boss}) do
    mana_cost = 53
    updated_boss = Map.update!(boss, :hp, fn hp -> hp - 4 end)
    updated_player = Map.update!(player, :mana, fn mana -> mana - mana_cost end)
    %{mana_spent: mana_spent + mana_cost, player: updated_player, boss: updated_boss}
  end

  # Drain costs 73 mana. It instantly does 2 damage and heals you for 2 hit points.
  def apply_spell(:drain, %{mana_spent: mana_spent, player: player, boss: boss}) do
    mana_cost = 73
    updated_boss = Map.update!(boss, :hp, fn hp -> hp - 2 end)

    updated_player =
      player
      |> Map.update!(:mana, fn mana -> mana - mana_cost end)
      |> Map.update!(:hp, fn hp -> hp + 2 end)

    %{
      mana_spent: mana_spent + mana_cost,
      player: updated_player,
      boss: updated_boss
    }
  end

  # Shield costs 113 mana. It starts an effect that lasts for 6 turns. While it is active, your armor is increased by 7.
  def apply_spell(:shield, %{mana_spent: mana_spent, player: player, boss: boss}) do
    mana_cost = 113

    updated_player =
      player
      |> Map.update!(:mana, fn mana -> mana - mana_cost end)
      |> Map.update!(:armor, fn armor -> armor + 7 end)
      |> Map.update!(:shield, fn shield -> shield + 6 end)

    %{mana_spent: mana_spent + mana_cost, player: updated_player, boss: boss}
  end

  # Poison costs 173 mana. It starts an effect that lasts for 6 turns. At the start of each turn while it is active, it deals the boss 3 damage.
  def apply_spell(:poison, %{mana_spent: mana_spent, player: player, boss: boss}) do
    mana_cost = 173
    updated_boss = Map.update!(boss, :poison, fn poison -> poison + 6 end)
    updated_player = Map.update!(player, :mana, fn mana -> mana - mana_cost end)

    %{
      mana_spent: mana_spent + mana_cost,
      player: updated_player,
      boss: updated_boss
    }
  end

  # Recharge costs 229 mana. It starts an effect that lasts for 5 turns. At the start of each turn while it is active, it gives you 101 new mana.
  def apply_spell(:recharge, %{mana_spent: mana_spent, player: player, boss: boss}) do
    mana_cost = 229

    updated_player =
      player
      |> Map.update!(:mana, fn mana -> mana - mana_cost end)
      |> Map.update!(:recharge, fn r -> r + 5 end)

    %{mana_spent: mana_spent + mana_cost, player: updated_player, boss: boss}
  end

  def apply_spell(:boss_attack, %{mana_spent: mana_spent, player: player, boss: boss}) do
    armor = Map.get(player, :armor)
    attack = Map.get(boss, :dmg)
    damage = Enum.max([1, attack - armor])

    updated_player = Map.update!(player, :hp, fn hp -> hp - damage end)

    %{mana_spent: mana_spent, player: updated_player, boss: boss}
  end
end
