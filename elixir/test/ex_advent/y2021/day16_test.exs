defmodule ExAdvent.Y2021.Day16Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day16

  test "parse input" do
    input = "D2FE28"
    assert parse_input(input) == '110100101111111000101000'
  end

  test "parse input - leading 0s" do
    input = "620"
    assert parse_input(input) == '011000100000'
  end

  test "sum_version_numbers - 8A004A801A8002F478" do
    assert sum_version_numbers(parse_input("8A004A801A8002F478")) == 16
  end

  test "calculate_value - C200B40A82 - sum" do
    assert calculate_value(parse_input("C200B40A82")) == 3
  end

  test "calculate_value - 04005AC33890 - product" do
    assert calculate_value(parse_input("04005AC33890")) == 54
  end

  test "calculate_value - 880086C3E88112 - minimum" do
    assert calculate_value(parse_input("880086C3E88112")) == 7
  end

  test "calculate_value - CE00C43D881120 - maximum" do
    assert calculate_value(parse_input("CE00C43D881120")) == 9
  end

  test "calculate_value - F600BC2D8F - greater than" do
    assert calculate_value(parse_input("F600BC2D8F")) == 0
  end

  test "calculate_value - D8005AC2A8F0 - less than" do
    assert calculate_value(parse_input("D8005AC2A8F0")) == 1
  end

  test "calculate_value - 9C005AC2F8F0 - not equal" do
    assert calculate_value(parse_input("9C005AC2F8F0")) == 0
  end

  test "calculate_value - 9C0141080250320F1802104A08 - equal" do
    assert calculate_value(parse_input("9C0141080250320F1802104A08")) == 1
  end

  test "parse_packet - 8A004A801A8002F478" do
    assert parse_packet(parse_input("8A004A801A8002F478")) == {
             %{
               subpackets: [
                 %{
                   subpackets: [
                     %{
                       subpackets: [
                         %{
                           subpackets: [],
                           value: 15,
                           version: 6,
                           type_id: :literal
                         }
                       ],
                       version: 5,
                       type_id: :minimum
                     }
                   ],
                   version: 1,
                   type_id: :minimum
                 }
               ],
               version: 4,
               type_id: :minimum
             },
             '000'
           }
  end

  test "parse_packet - 620080001611562C8802118E34" do
    assert parse_packet(parse_input("620080001611562C8802118E34")) == {
             %{
               subpackets: [
                 %{
                   subpackets: [
                     %{
                       subpackets: [],
                       value: 10,
                       version: 0,
                       type_id: :literal
                     },
                     %{
                       subpackets: [],
                       value: 11,
                       version: 5,
                       type_id: :literal
                     }
                   ],
                   version: 0,
                   type_id: :sum
                 },
                 %{
                   subpackets: [
                     %{
                       subpackets: [],
                       value: 12,
                       version: 0,
                       type_id: :literal
                     },
                     %{
                       subpackets: [],
                       value: 13,
                       version: 3,
                       type_id: :literal
                     }
                   ],
                   version: 1,
                   type_id: :sum
                 }
               ],
               version: 3,
               type_id: :sum
             },
             '00'
           }
  end

  test "parse_packet - C0015000016115A2E0802F182340" do
    assert parse_packet(parse_input("C0015000016115A2E0802F182340")) == {
             %{
               subpackets: [
                 %{
                   subpackets: [
                     %{
                       subpackets: [],
                       value: 10,
                       version: 0,
                       type_id: :literal
                     },
                     %{
                       subpackets: [],
                       value: 11,
                       version: 6,
                       type_id: :literal
                     }
                   ],
                   version: 0,
                   type_id: :sum
                 },
                 %{
                   subpackets: [
                     %{
                       subpackets: [],
                       value: 12,
                       version: 7,
                       type_id: :literal
                     },
                     %{
                       subpackets: [],
                       value: 13,
                       version: 0,
                       type_id: :literal
                     }
                   ],
                   version: 4,
                   type_id: :sum
                 }
               ],
               version: 6,
               type_id: :sum
             },
             '000000'
           }
  end

  test "parse_packet - A0016C880162017C3686B18A3D4780" do
    assert parse_packet(parse_input("A0016C880162017C3686B18A3D4780")) == {
             %{
               subpackets: [
                 %{
                   subpackets: [
                     %{
                       subpackets: [
                         %{
                           subpackets: [],
                           value: 6,
                           version: 7,
                           type_id: :literal
                         },
                         %{
                           subpackets: [],
                           value: 6,
                           version: 6,
                           type_id: :literal
                         },
                         %{
                           subpackets: [],
                           value: 12,
                           version: 5,
                           type_id: :literal
                         },
                         %{
                           subpackets: [],
                           value: 15,
                           version: 2,
                           type_id: :literal
                         },
                         %{
                           subpackets: [],
                           value: 15,
                           version: 2,
                           type_id: :literal
                         }
                       ],
                       version: 3,
                       type_id: :sum
                     }
                   ],
                   version: 1,
                   type_id: :sum
                 }
               ],
               version: 5,
               type_id: :sum
             },
             '0000000'
           }
  end

  test "parse_literal_value" do
    assert parse_literal_value('101111111000101000') == {2021, '000'}
  end

  test "parse_fixed_length_packet" do
    assert parse_fixed_length_packet('0000000000110111101000101001010010001001000000000') == {
             [
               %{
                 subpackets: [],
                 type_id: :literal,
                 value: 10,
                 version: 6
               },
               %{
                 subpackets: [],
                 type_id: :literal,
                 value: 20,
                 version: 2
               }
             ],
             '0000000'
           }
  end

  test "parse_subpacket_count_packet" do
    assert parse_subpacket_count_packet('0000000001101010000001100100000100011000001100000') == {
             [
               %{
                 subpackets: [],
                 value: 1,
                 version: 2,
                 type_id: :literal
               },
               %{
                 subpackets: [],
                 value: 2,
                 version: 4,
                 type_id: :literal
               },
               %{
                 subpackets: [],
                 value: 3,
                 version: 1,
                 type_id: :literal
               }
             ],
             '00000'
           }
  end
end
