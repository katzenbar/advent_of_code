defmodule ExAdvent.Y2022.Day03Test do
  use ExUnit.Case

  import ExAdvent.Y2022.Day03

  def sample_input() do
    ~s"""
    vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() == [
             'vJrwpWtwJgWrhcsFMMfFFhFp',
             'jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL',
             'PmmdzqPrVvPwwTWBwg',
             'wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn',
             'ttgJtRGJQctTZtZT',
             'CrZsJsPPZsGzwwsLwLmpwMDw'
           ]
  end

  test "find_rucksack_common_item" do
    assert find_rucksack_common_item({'vJrwpWtwJgWr', 'hcsFMMfFFhFp'}) == ?p
  end

  test "item_priority - lowercase" do
    assert item_priority(?c) == 3
  end

  test "item_priority - uppercase" do
    assert item_priority(?D) == 30
  end

  test "find_items_to_rearrange" do
    assert find_items_to_rearrange(parsed_sample_input()) == 157
  end

  test "find_badge_priorities" do
    assert find_badge_priorities(parsed_sample_input()) == 70
  end

  test "find_badge_in_group" do
    assert find_badge_in_group(['vJrwpWtwJgWrhcsFMMfFFhFp', 'jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL', 'PmmdzqPrVvPwwTWBwg']) ==
             ?r
  end
end
