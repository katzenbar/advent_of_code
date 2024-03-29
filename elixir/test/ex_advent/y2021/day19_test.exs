defmodule ExAdvent.Y2021.Day19Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day19

  def sample_input() do
    ~s"""
    --- scanner 0 ---
    404,-588,-901
    528,-643,409
    -838,591,734
    390,-675,-793
    -537,-823,-458
    -485,-357,347
    -345,-311,381
    -661,-816,-575
    -876,649,763
    -618,-824,-621
    553,345,-567
    474,580,667
    -447,-329,318
    -584,868,-557
    544,-627,-890
    564,392,-477
    455,729,728
    -892,524,684
    -689,845,-530
    423,-701,434
    7,-33,-71
    630,319,-379
    443,580,662
    -789,900,-551
    459,-707,401

    --- scanner 1 ---
    686,422,578
    605,423,415
    515,917,-361
    -336,658,858
    95,138,22
    -476,619,847
    -340,-569,-846
    567,-361,727
    -460,603,-452
    669,-402,600
    729,430,532
    -500,-761,534
    -322,571,750
    -466,-666,-811
    -429,-592,574
    -355,545,-477
    703,-491,-529
    -328,-685,520
    413,935,-424
    -391,539,-444
    586,-435,557
    -364,-763,-893
    807,-499,-711
    755,-354,-619
    553,889,-390

    --- scanner 2 ---
    649,640,665
    682,-795,504
    -784,533,-524
    -644,584,-595
    -588,-843,648
    -30,6,44
    -674,560,763
    500,723,-460
    609,671,-379
    -555,-800,653
    -675,-892,-343
    697,-426,-610
    578,704,681
    493,664,-388
    -671,-858,530
    -667,343,800
    571,-461,-707
    -138,-166,112
    -889,563,-600
    646,-828,498
    640,759,510
    -630,509,768
    -681,-892,-333
    673,-379,-804
    -742,-814,-386
    577,-820,562

    --- scanner 3 ---
    -589,542,597
    605,-692,669
    -500,565,-823
    -660,373,557
    -458,-679,-417
    -488,449,543
    -626,468,-788
    338,-750,-386
    528,-832,-391
    562,-778,733
    -938,-730,414
    543,643,-506
    -524,371,-870
    407,773,750
    -104,29,83
    378,-903,-323
    -778,-728,485
    426,699,580
    -438,-605,-362
    -469,-447,-387
    509,732,623
    647,635,-688
    -868,-804,481
    614,-800,639
    595,780,-596

    --- scanner 4 ---
    727,592,562
    -293,-554,779
    441,611,-461
    -714,465,-776
    -743,427,-804
    -660,-479,-426
    832,-632,460
    927,-485,-438
    408,393,-506
    466,436,-512
    110,16,151
    -258,-428,682
    -393,719,612
    -211,-452,876
    808,-476,-593
    -575,615,604
    -485,667,467
    -680,325,-822
    -627,-443,-432
    872,-547,-609
    833,512,582
    807,604,487
    839,-516,451
    891,-625,532
    -652,-548,-490
    30,-46,-14
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    input = ~s"""
    --- scanner 0 ---
    -1,-1,1
    -2,-2,2
    -3,-3,3
    -2,-3,1
    5,6,-4
    8,0,7

    --- scanner 1 ---
    1,-1,1
    2,-2,2
    3,-3,3
    2,-1,3
    -5,4,-6
    -8,-7,0
    """

    assert parse_input(input) == [
             [{-1, -1, 1}, {-2, -2, 2}, {-3, -3, 3}, {-2, -3, 1}, {5, 6, -4}, {8, 0, 7}],
             [{1, -1, 1}, {2, -2, 2}, {3, -3, 3}, {2, -1, 3}, {-5, 4, -6}, {-8, -7, 0}]
           ]
  end

  test "get_relative_positions_for_points" do
    points = [{-1, -1, 1}, {-2, -2, 2}, {-3, -3, 3}, {-2, -3, 1}, {5, 6, -4}, {8, 0, 7}]

    expected = [
      {
        {-1, -1, 1},
        MapSet.new([{-9, -1, -6}, {-6, -7, 5}, {0, 0, 0}, {1, 1, -1}, {1, 2, 0}, {2, 2, -2}])
      },
      {
        {-2, -2, 2},
        MapSet.new([{-10, -2, -5}, {-7, -8, 6}, {-1, -1, 1}, {0, 0, 0}, {0, 1, 1}, {1, 1, -1}])
      },
      {
        {-3, -3, 3},
        MapSet.new([{-11, -3, -4}, {-8, -9, 7}, {-2, -2, 2}, {-1, -1, 1}, {-1, 0, 2}, {0, 0, 0}])
      },
      {
        {-2, -3, 1},
        MapSet.new([{-10, -3, -6}, {-7, -9, 5}, {-1, -2, 0}, {0, -1, -1}, {0, 0, 0}, {1, 0, -2}])
      },
      {
        {5, 6, -4},
        MapSet.new([{-3, 6, -11}, {0, 0, 0}, {6, 7, -5}, {7, 8, -6}, {7, 9, -5}, {8, 9, -7}])
      },
      {
        {8, 0, 7},
        MapSet.new([{0, 0, 0}, {3, -6, 11}, {9, 1, 6}, {10, 2, 5}, {10, 3, 6}, {11, 3, 4}])
      }
    ]

    assert get_relative_positions_for_points(points) == expected
  end

  test "get_rotations" do
    points = [{-660, -479, -426}, {-391, 539, -444}]

    assert Enum.to_list(get_rotations(points)) ==
             [
               [{-660, -479, -426}, {-391, 539, -444}],
               [{-660, 426, -479}, {-391, 444, 539}],
               [{-660, 479, 426}, {-391, -539, 444}],
               [{-660, -426, 479}, {-391, -444, -539}],
               [{660, 479, -426}, {391, -539, -444}],
               [{660, 426, 479}, {391, 444, -539}],
               [{660, -479, 426}, {391, 539, 444}],
               [{660, -426, -479}, {391, -444, 539}],
               [{-479, 660, -426}, {539, 391, -444}],
               [{-479, 426, 660}, {539, 444, 391}],
               [{-479, -660, 426}, {539, -391, 444}],
               [{-479, -426, -660}, {539, -444, -391}],
               [{479, -660, -426}, {-539, -391, -444}],
               [{479, 660, 426}, {-539, 391, 444}],
               [{479, 426, -660}, {-539, 444, -391}],
               [{479, -426, 660}, {-539, -444, 391}],
               [{-426, -660, -479}, {-444, -391, 539}],
               [{-426, 660, 479}, {-444, 391, -539}],
               [{-426, 479, -660}, {-444, -539, -391}],
               [{-426, -479, 660}, {-444, 539, 391}],
               [{426, 660, -479}, {444, 391, 539}],
               [{426, -660, 479}, {444, -391, -539}],
               [{426, -479, -660}, {444, 539, -391}],
               [{426, 479, 660}, {444, -539, 391}]
             ]
  end

  test "move_points_to_reference_frame" do
    input = ~s"""
    --- scanner 0 ---
    404,-588,-901
    528,-643,409
    -838,591,734
    390,-675,-793
    -537,-823,-458
    -485,-357,347
    -345,-311,381
    -661,-816,-575
    -876,649,763
    -618,-824,-621
    553,345,-567
    474,580,667
    -447,-329,318
    -584,868,-557
    544,-627,-890
    564,392,-477
    455,729,728
    -892,524,684
    -689,845,-530
    423,-701,434
    7,-33,-71
    630,319,-379
    443,580,662
    -789,900,-551
    459,-707,401

    --- scanner 1 ---
    686,422,578
    605,423,415
    515,917,-361
    -336,658,858
    95,138,22
    -476,619,847
    -340,-569,-846
    567,-361,727
    -460,603,-452
    669,-402,600
    729,430,532
    -500,-761,534
    -322,571,750
    -466,-666,-811
    -429,-592,574
    -355,545,-477
    703,-491,-529
    -328,-685,520
    413,935,-424
    -391,539,-444
    586,-435,557
    -364,-763,-893
    807,-499,-711
    755,-354,-619
    553,889,-390
    """

    [scanner_zero, scanner_one] = parse_input(input)

    assert move_points_to_reference_frame(scanner_zero, scanner_one) ==
             {{68, -1246, -43},
              [
                {-618, -824, -621},
                {-537, -823, -458},
                {-447, -329, 318},
                {404, -588, -901},
                {-27, -1108, -65},
                {544, -627, -890},
                {408, -1815, 803},
                {-499, -1607, -770},
                {528, -643, 409},
                {-601, -1648, -643},
                {-661, -816, -575},
                {568, -2007, -577},
                {390, -675, -793},
                {534, -1912, 768},
                {497, -1838, -617},
                {423, -701, 434},
                {-635, -1737, 486},
                {396, -1931, -563},
                {-345, -311, 381},
                {459, -707, 401},
                {-518, -1681, -600},
                {432, -2009, 850},
                {-739, -1745, 668},
                {-687, -1600, 576},
                {-485, -357, 347}
              ]}
  end

  test "match_beacons" do
    assert match_beacons(parsed_sample_input()) == [
             {{-20, -1133, 1061},
              [
                {-612, -1695, 1788},
                {534, -1912, 768},
                {-631, -672, 1502},
                {-485, -357, 347},
                {-447, -329, 318},
                {459, -707, 401},
                {612, -1593, 1893},
                {465, -695, 1988},
                {-413, -627, 1469},
                {-456, -621, 1527},
                {-36, -1284, 1171},
                {408, -1815, 803},
                {-739, -1745, 668},
                {432, -2009, 850},
                {456, -540, 1869},
                {-635, -1737, 486},
                {-687, -1600, 576},
                {-345, -311, 381},
                {423, -701, 434},
                {527, -524, 1933},
                {-532, -1715, 1894},
                {-624, -1620, 1868},
                {496, -1584, 1900},
                {605, -1665, 1952},
                {528, -643, 409},
                {26, -1119, 1091}
              ]},
             {{-92, -2380, -20},
              [
                {497, -1838, -617},
                {-697, -3072, -689},
                {408, -1815, 803},
                {568, -2007, -577},
                {366, -3059, 397},
                {396, -1931, -563},
                {534, -1912, 768},
                {-430, -3130, 366},
                {-620, -3212, 371},
                {-654, -3158, -753},
                {846, -3110, -434},
                {-635, -1737, 486},
                {432, -2009, 850},
                {-499, -1607, -770},
                {12, -2351, -103},
                {-470, -3283, 303},
                {686, -3108, -505},
                {-518, -1681, -600},
                {346, -2985, 342},
                {377, -2827, 367},
                {-601, -1648, -643},
                {-739, -1745, 668},
                {776, -3184, -501},
                {-706, -3180, -659},
                {-687, -1600, 576}
              ]},
             {{68, -1246, -43},
              [
                {-618, -824, -621},
                {-537, -823, -458},
                {-447, -329, 318},
                {404, -588, -901},
                {-27, -1108, -65},
                {544, -627, -890},
                {408, -1815, 803},
                {-499, -1607, -770},
                {528, -643, 409},
                {-601, -1648, -643},
                {-661, -816, -575},
                {568, -2007, -577},
                {390, -675, -793},
                {534, -1912, 768},
                {497, -1838, -617},
                {423, -701, 434},
                {-635, -1737, 486},
                {396, -1931, -563},
                {-345, -311, 381},
                {459, -707, 401},
                {-518, -1681, -600},
                {432, -2009, 850},
                {-739, -1745, 668},
                {-687, -1600, 576},
                {-485, -357, 347}
              ]},
             {{0, 0, 0},
              [
                {404, -588, -901},
                {528, -643, 409},
                {-838, 591, 734},
                {390, -675, -793},
                {-537, -823, -458},
                {-485, -357, 347},
                {-345, -311, 381},
                {-661, -816, -575},
                {-876, 649, 763},
                {-618, -824, -621},
                {553, 345, -567},
                {474, 580, 667},
                {-447, -329, 318},
                {-584, 868, -557},
                {544, -627, -890},
                {564, 392, -477},
                {455, 729, 728},
                {-892, 524, 684},
                {-689, 845, -530},
                {423, -701, 434},
                {7, -33, -71},
                {630, 319, -379},
                {443, 580, 662},
                {-789, 900, -551},
                {459, -707, 401}
              ]},
             {{1105, -1205, 1229},
              [
                {456, -540, 1869},
                {423, -701, 434},
                {1889, -1729, 1762},
                {1749, -1800, 1813},
                {1693, -557, 386},
                {1135, -1161, 1235},
                {1779, -442, 1789},
                {605, -1665, 1952},
                {496, -1584, 1900},
                {1660, -552, 429},
                {1780, -1548, 337},
                {408, -1815, 803},
                {527, -524, 1933},
                {612, -1593, 1893},
                {1776, -675, 371},
                {1772, -405, 1572},
                {534, -1912, 768},
                {1243, -1093, 1063},
                {1994, -1805, 1792},
                {459, -707, 401},
                {465, -695, 1988},
                {1735, -437, 1738},
                {1786, -1538, 337},
                {432, -2009, 850},
                {1847, -1591, 415},
                {528, -643, 409}
              ]}
           ]
  end

  test "count_beacons" do
    assert count_beacons(parsed_sample_input()) == 79
  end

  test "find_scanners_furthest_apart" do
    assert find_scanners_furthest_apart(parsed_sample_input()) == 3621
  end
end
