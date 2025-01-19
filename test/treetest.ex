defmodule BinarytreesTest do
  use ExUnit.Case
  alias Binarytrees

  test "valid tree" do
    tree = %{
      value: 1,
      left: %{
        value: 2,
        right: nil,
        left: nil
      },
      right: %{
        value: 2,
        right: nil,
        left: nil
      }
    }
    assert Binarytrees.isTree(tree, false) == true
  end

  test "invalid tree with missing left key" do
    invalid_tree = %{
      value: 1,
      left: %{
        value: 2,
        right: nil
        # missing left key
      },
      right: %{
        value: 3,
        left: nil,
        right: %{
          value: 4
          # missing left and right keys
        }
      }
    }
    assert Binarytrees.isTree(invalid_tree, false) == false
  end

  test "tree with only root node" do
    tree = %{
      value: 1,
      left: nil,
      right: nil
    }
    assert Binarytrees.isTree(tree, false) == true
  end

  test "tree with only left child" do
    tree = %{
      value: 1,
      left: %{
        value: 2,
        left: nil,
        right: nil
      },
      right: nil
    }
    assert Binarytrees.isTree(tree, false) == true
  end

  test "tree with only right child" do
    tree = %{
      value: 1,
      left: nil,
      right: %{
        value: 2,
        left: nil,
        right: nil
      }
    }
    assert Binarytrees.isTree(tree, false) == true
  end

  test "invalid tree with missing right key" do
    invalid_tree = %{
      value: 1,
      left: %{
        value: 2,
        left: nil,
        right: nil
      }
      # missing right key
    }
    assert Binarytrees.isTree(invalid_tree, false) == false
  end
end
