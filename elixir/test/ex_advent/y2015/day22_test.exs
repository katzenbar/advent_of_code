defmodule ExAdvent.Y2015.Day22Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day22

  test "parse input" do
    input = ~s"""
    Hit Points: 55
    Damage: 8
    """

    assert parse_input(input) == {55, 8}
  end

  # -- Player turn --
  # - Player has 10 hit points, 0 armor, 250 mana
  # - Boss has 13 hit points
  # Player casts Poison.
  test "simulate_action - apply poison" do
    game_state = %{
      mana_spent: 0,
      player: %{hp: 10, armor: 0, mana: 250, shield: 0, recharge: 0},
      boss: %{hp: 13, dmg: 8, poison: 0}
    }

    expected = %{
      mana_spent: 173,
      player: %{hp: 10, armor: 0, mana: 77, shield: 0, recharge: 0},
      boss: %{hp: 13, dmg: 8, poison: 6}
    }

    assert simulate_action(game_state, :poison) == expected
  end

  # -- Boss turn --
  # - Player has 10 hit points, 0 armor, 77 mana
  # - Boss has 13 hit points
  # Poison deals 3 damage; its timer is now 5.
  # Boss attacks for 8 damage.
  test "simulate_action - boss attack" do
    game_state = %{
      mana_spent: 173,
      player: %{hp: 10, armor: 0, mana: 77, shield: 0, recharge: 0},
      boss: %{hp: 13, dmg: 8, poison: 6}
    }

    expected = %{
      mana_spent: 173,
      player: %{hp: 2, armor: 0, mana: 77, shield: 0, recharge: 0},
      boss: %{hp: 10, dmg: 8, poison: 5}
    }

    assert simulate_action(game_state, :boss_attack) == expected
  end

  # -- Player turn --
  # - Player has 2 hit points, 0 armor, 77 mana
  # - Boss has 10 hit points
  # Poison deals 3 damage; its timer is now 4.
  # Player casts Magic Missile, dealing 4 damage.
  test "simulate_action - magic missle" do
    game_state = %{
      mana_spent: 173,
      player: %{hp: 2, armor: 0, mana: 77, shield: 0, recharge: 0},
      boss: %{hp: 10, dmg: 8, poison: 5}
    }

    expected = %{
      mana_spent: 226,
      player: %{hp: 2, armor: 0, mana: 24, shield: 0, recharge: 0},
      boss: %{hp: 3, dmg: 8, poison: 4}
    }

    assert simulate_action(game_state, :magic_missile) == expected
  end

  # -- Boss turn --
  # - Player has 2 hit points, 0 armor, 24 mana
  # - Boss has 3 hit points
  # Poison deals 3 damage. This kills the boss, and the player wins.
  test "simulate_action - boss dies by poison on their turn" do
    game_state = %{
      mana_spent: 226,
      player: %{hp: 2, armor: 0, mana: 24, shield: 0, recharge: 0},
      boss: %{hp: 3, dmg: 8, poison: 4}
    }

    expected = %{
      mana_spent: 226,
      player: %{hp: 2, armor: 0, mana: 24, shield: 0, recharge: 0},
      boss: %{hp: 0, dmg: 8, poison: 3}
    }

    assert simulate_action(game_state, :boss_attack) == expected
  end

  test "simulate_turns - sample game" do
    result =
      simulate_turns(
        [
          %{
            mana_spent: 0,
            player: %{hp: 10, armor: 0, mana: 250, shield: 0, recharge: 0},
            boss: %{hp: 13, dmg: 8, poison: 0}
          }
        ],
        :player
      )

    expected = %{
      boss: %{dmg: 8, hp: 0, poison: 3},
      mana_spent: 226,
      player: %{armor: 0, hp: 2, mana: 24, recharge: 0, shield: 0}
    }

    assert result == expected
  end
end
