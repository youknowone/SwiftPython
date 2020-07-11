@testable import BigInt

// swiftlint:disable number_separator

internal enum MinRequiredWidthTestCases {

  // MARK: - Smi

  internal typealias SmiTestCase = (value: Smi.Storage, expected: Int)

  internal static let smi: [SmiTestCase] = [
    (0, 0),
    (1, 1),
    (-1, 1),
    (2147483647, 31),
    (-2147483647, 31),
    (1073741823, 30),
    (-1073741823, 30),
    (536870911, 29),
    (-536870911, 29),
    (268435455, 28),
    (-268435455, 28),
    (134217727, 27),
    (-134217727, 27),
    (67108863, 26),
    (-67108863, 26),
    (33554431, 25),
    (-33554431, 25),
    (16777215, 24),
    (-16777215, 24),
    (8388607, 23),
    (-8388607, 23),
    (4194303, 22),
    (-4194303, 22),
    (2097151, 21),
    (-2097151, 21),
    (1048575, 20),
    (-1048575, 20),
    (524287, 19),
    (-524287, 19),
    (262143, 18),
    (-262143, 18),
    (131071, 17),
    (-131071, 17),
    (65535, 16),
    (-65535, 16),
    (32767, 15),
    (-32767, 15),
    (16383, 14),
    (-16383, 14),
    (8191, 13),
    (-8191, 13),
    (4095, 12),
    (-4095, 12),
    (2047, 11),
    (-2047, 11),
    (1023, 10),
    (-1023, 10),
    (511, 9),
    (-511, 9),
    (255, 8),
    (-255, 8),
    (127, 7),
    (-127, 7),
    (63, 6),
    (-63, 6),
    (31, 5),
    (-31, 5),
    (15, 4),
    (-15, 4),
    (7, 3),
    (-7, 3),
    (3, 2),
    (-3, 2),
    (1, 1),
    (-1, 1)
  ]

  // MARK: - Heap

  internal typealias HeapTestCase = (string: String, expected: Int)

  internal static let heap: [HeapTestCase] = [
    ("2147483648", 32), // Smi.Storage.max + 1
    ("-2147483649", 32), // Smi.Storage.min - 1
    ("18446744073709551615", 64),
    ("-18446744073709551615", 64),
    ("23514513329", 35),
    ("-23514513329", 35),
    ("57411132388333261745045211909989318793", 126),
    ("-57411132388333261745045211909989318793", 126),
    ("40991309141305970415097211664579785037045427947209", 165),
    ("-40991309141305970415097211664579785037045427947209", 165),
    ("21509441615044013666", 65),
    ("-21509441615044013666", 65),
    ("55637721945066415320110804879921305", 116),
    ("-55637721945066415320110804879921305", 116),
    ("54346816106845892627559644493667174774801022698466767438", 186),
    ("-54346816106845892627559644493667174774801022698466767438", 186),
    ("425997469803260", 49),
    ("-425997469803260", 49),
    ("5834332435025742254798976721507", 103),
    ("-5834332435025742254798976721507", 103),
    ("4649166320872497633237570411863817474872261618944", 162),
    ("-4649166320872497633237570411863817474872261618944", 162),
    ("700679253348", 40),
    ("-700679253348", 40),
    ("6165438362264015996584621943107683", 113),
    ("-6165438362264015996584621943107683", 113),
    ("10438265908450312021753473709076732253476693597171", 163),
    ("-10438265908450312021753473709076732253476693597171", 163),
    ("6229580095839", 43),
    ("-6229580095839", 43),
    ("86851694080201436088864194731686611", 117),
    ("-86851694080201436088864194731686611", 117),
    ("6384007842076907315614110557031595749145226518720250", 173),
    ("-6384007842076907315614110557031595749145226518720250", 173),
    ("6436045000233750", 53),
    ("-6436045000233750", 53),
    ("19017547940866849558477050774849", 104),
    ("-19017547940866849558477050774849", 104),
    ("555908379999574355910557316651143016404240727677021", 169),
    ("-555908379999574355910557316651143016404240727677021", 169),
    ("865110555770328748", 60),
    ("-865110555770328748", 60),
    ("50087959914694638821966142902036604", 116),
    ("-50087959914694638821966142902036604", 116),
    ("228234312082525496356484855635052834335585035206151387922", 188),
    ("-228234312082525496356484855635052834335585035206151387922", 188),
    ("336933253522733390", 59),
    ("-336933253522733390", 59),
    ("8004409538868719740413891792756", 103),
    ("-8004409538868719740413891792756", 103),
    ("2704283146063867933142402580521695885748456452752737655", 181),
    ("-2704283146063867933142402580521695885748456452752737655", 181),
    ("691225164863908", 50),
    ("-691225164863908", 50),
    ("4281854745469325249068756887679", 102),
    ("-4281854745469325249068756887679", 102),
    ("8359346852749522442046270942743790822214582948468307454121", 193),
    ("-8359346852749522442046270942743790822214582948468307454121", 193),
    ("19734776918", 35),
    ("-19734776918", 35),
    ("367344001789195810037324021569761816", 119),
    ("-367344001789195810037324021569761816", 119),
    ("199490024251093353013717703219814220032216652412483", 168),
    ("-199490024251093353013717703219814220032216652412483", 168)
  ]
}