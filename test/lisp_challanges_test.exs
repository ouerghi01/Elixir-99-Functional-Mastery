defmodule LispChallangesTest do
  use ExUnit.Case
  doctest LispChallanges

  test "p01 test" do
    assert LispChallanges.test_p01([1,2,3]) == 3
  end

  test "p02 test" do
    assert LispChallanges.test_p02([1,2,3]) == [2,3]
  end

  test "p03 test" do
    assert LispChallanges.test_p03([1,4,3],2) == 4
  end

  test "p04 test" do
    assert LispChallanges.test_p04([1,4]) != 3
  end

  test "p05 test" do
    assert LispChallanges.test_p05([1,2,3]) == [3,2,1]
  end

  test "p06 test" do
    assert LispChallanges.test_p06(["x","a","m"],["m","a","x",]) == true
  end

  test "p07 test" do
    assert LispChallanges.test_p07([1,[1,3],[4,5],[6,[1,2]]]) == [1,1,3,4,5,6,1,2]
  end

  test "p08 test" do
    assert LispChallanges.test_p08("a a a a b c c a a d e e e e" |> String.split(" ")) == "a b c a d e" |> String.split(" ")
  end

  test "p09 test" do
    assert LispChallanges.test_p09("a a a a b c c a a d e e e e" |> String.split(" ")) == [["a","a","a","a"],["b"],["c","c"],["a","a"],["d"],["e","e","e","e"]]
  end

  test "p09 test with single element list" do
    assert LispChallanges.test_p09(["a"]) == [["a"]]
  end

  test "p09 test with no repeated elements" do
    assert LispChallanges.test_p09(["a", "b", "c", "d"]) == [["a"], ["b"], ["c"], ["d"]]
  end

  test "p09 test with all elements the same" do
    assert LispChallanges.test_p09(["a", "a", "a", "a"]) == [["a", "a", "a", "a"]]
  end

  test "p09 test with mixed elements" do
    assert LispChallanges.test_p09(["a", "b", "b", "c", "a", "a", "d", "e", "e"]) == [["a"], ["b", "b"], ["c"], ["a", "a"], ["d"], ["e", "e"]]
  end

  test "p10 test : run-length encoding data compression method" do
    assert LispChallanges.test_p010(["a", "b", "b", "c", "a", "a", "d", "e", "e"]) == [[1,"a"],[2,"b"],[1,"c"],[2,"a"],[1,"d"],[2,"e"]]
  end

  test "p10 v2 test : run-length encoding with single element" do
    assert LispChallanges.test_p010(["a"]) == [[1, "a"]]
  end
  test "p11 test : run-length encoding with single element" do
    assert LispChallanges.test_p11(["a", "b", "b", "c", "a", "a", "d", "e", "e"]) == [["a"],[2,"b"],["c"],[2,"a"],["d"],[2,"e"]]

  end
  test "p12 test : run-length decoding" do
    assert LispChallanges.test_p12([["a"],[2,"b"],["c"],[2,"a"],["d"],[2,"e"]]) == ["a", "b", "b", "c", "a", "a", "d", "e", "e"]

  end
  test "p14 : replicate 1 " do
    assert LispChallanges.test_p14(["a","b","c","d"],2) == ["a", "a","b","b","c","c","d","d"]
  end

  test "p15 : replicate 3 " do
    assert LispChallanges.test_p14(["a","b","c","d"],3) == ["a", "a", "a", "b", "b", "b", "c", "c", "c", "d", "d", "d"]
  end
  test "p16 : Drop every 3rd element from a list" do
    assert LispChallanges.test_p16(["a", "b", "c", "d", "e", "f", "g", "h", "i", "k"], 3) == ["a", "b", "d", "e", "g", "h", "k"]
  end

  test "p16 : Drop every 2nd element from a list" do
    assert LispChallanges.test_p16(["a", "b", "c", "d", "e", "f", "g", "h", "i", "k"], 2) == ["a", "c", "e", "g", "i"]
  end

  test "p16 : Drop every 1st element from a list" do
    assert LispChallanges.test_p16(["a", "b", "c", "d", "e", "f", "g", "h", "i", "k"], 1) == []
  end

  test "p16 : Drop every 4th element from a list" do
    assert LispChallanges.test_p16(["a", "b", "c", "d", "e", "f", "g", "h", "i", "k"], 4) == ["a", "b", "c", "e", "f", "g", "i", "k"]
  end

  test "p16 : Drop every 5th element from a list" do
    assert LispChallanges.test_p16(["a", "b", "c", "d", "e", "f", "g", "h", "i", "k"], 5) == ["a", "b", "c", "d", "f", "g", "h", "i"]
  end
  test "p17 : Split a list into two parts; the length of the first part is given" do
    assert LispChallanges.test_p17(["a", "b", "c", "d", "e", "f", "g", "h", "i", "k"], 3) == {["a", "b", "c"], ["d", "e", "f", "g", "h", "i", "k"]}
  end

  test "p17 : Split a list into two parts with length 1" do
    assert LispChallanges.test_p17(["a", "b", "c", "d"], 1) == {["a"], ["b", "c", "d"]}
  end

  test "p17 : Split a list into two parts with length 0" do
    assert LispChallanges.test_p17(["a", "b", "c", "d"], 0) == {[], ["a", "b", "c", "d"]}
  end

  test "p17 : Split a list into two parts with length equal to list length" do
    assert LispChallanges.test_p17(["a", "b", "c", "d"], 4) == {["a", "b", "c", "d"], []}
  end

  test "p17 : Split a list into two parts with length greater than list length" do
    assert LispChallanges.test_p17(["a", "b", "c", "d"], 5) == {["a", "b", "c", "d"], []}
  end

  test "p17 : Split an empty list" do
    assert LispChallanges.test_p17([], 3) == {[], []}
  end
  test "p18 : Extract a slice from a list" do
    assert LispChallanges.test_p18(["a", "b", "c", "d", "e", "f", "g", "h", "i", "k"], 3, 7) == ["c", "d", "e", "f", "g"]
  end

  test "p18 : Extract a slice from a list with start index 1" do
    assert LispChallanges.test_p18(["a", "b", "c", "d", "e", "f", "g", "h", "i", "k"], 1, 3) == ["a", "b", "c"]
  end

  test "p18 : Extract a slice from a list with end index equal to list length" do
    assert LispChallanges.test_p18(["a", "b", "c", "d", "e", "f", "g", "h", "i", "k"], 8, 10) == ["h", "i", "k"]
  end

  test "p18 : Extract a slice from a list with start index greater than end index" do
    assert LispChallanges.test_p18(["a", "b", "c", "d", "e", "f", "g", "h", "i", "k"], 7, 3) == []
  end

  test "p18 : Extract a slice from an empty list" do
    assert LispChallanges.test_p18([], 3, 7) == []
  end



end
