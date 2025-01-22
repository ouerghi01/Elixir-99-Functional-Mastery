defmodule Binarytrees do
  # p54
  def is_tree(nil), do: true

  def is_tree(tree) do
    [:left, :right]
    |> Task.async_stream(fn child ->
      case Map.fetch(tree, child) do
        :error -> false
        {:ok, sub} -> is_tree(sub)
      end
    end)
    |> Enum.all?(fn {:ok, res} -> res end)
  end

  def cbal_tree(0), do: [nil]

  def cbal_tree(n) when n > 0 do
    n0 = n - 1
    n1 = div(n0, 2)
    n2 = n0 - n1

    for {nl, nr} <- distrib(n1, n2),
        left <- cbal_tree(nl),
        right <- cbal_tree(nr) do
      %{value: "x", left: left, right: right}
    end
  end

  defp distrib(n, n), do: [{n, n}]
  defp distrib(n1, n2), do: [{n1, n2}, {n2, n1}]

  def symmetric(nil), do: mirror(nil, nil)
  def symmetric(%{left: left, right: right}), do: mirror(left, right)

  defp mirror(nil, nil), do: true
  defp mirror(nil, _), do: false
  defp mirror(_, nil), do: false

  defp mirror(%{value: _, left: left, right: right}, %{value: _, left: left1, right: right1}),
    do: mirror(left, right1) and mirror(left1, right)

  def construct([head | t], nil), do: construct(t, %{value: head, left: nil, right: nil})
  def construct([], nil), do: nil
  def construct([], tree), do: tree

  def construct([head | tail], %{value: value, left: left, right: right}) when head < value do
    construct(tail, %{value: value, left: construct([head], left), right: right})
  end

  def construct([head | tail], %{value: value, left: left, right: right}) when head > value do
    construct(tail, %{value: value, left: left, right: construct([head], right)})
  end

  def construct([head | tail], %{value: head, left: left, right: right}) do
    min_1 = Enum.find(tail, fn x -> x < head end)
    max_1 = Enum.find(tail, fn x -> x > head and x <= Enum.max(tail) end)

    new_tree =
      cond do
        left == nil and right == nil ->
          construct(
            tail,
            %{
              value: head,
              left: %{value: min_1, left: nil, right: nil},
              right: %{value: max_1, left: nil, right: nil}
            }
          )

        left == nil and right != nil ->
          new_node = %{value: head, left: %{value: min_1, left: nil, right: nil}, right: right}
          construct(tail, new_node)

        right == nil and left != nil ->
          new_node = %{value: head, right: %{value: max_1, left: nil, right: nil}, left: left}
          construct(tail, new_node)

        true ->
          new_node = %{value: head, left: left, right: right}
          construct(tail, new_node)
      end

    new_tree
  end

  # Generate-and-test paradigm
  def sym_cbal_trees(n), do: cbal_tree(n) |> Enum.filter(fn tree -> symmetric(tree) end)

  def is_high_balanced(nil), do: true

  def is_high_balanced(%{value: _, left: left, right: right}) do
    abs(high_node(left) - high_node(right)) <= 1
  end

  def high_node(nil), do: 0
  def high_node(%{value: _, left: nil, right: nil}), do: 1

  def high_node(%{value: _, left: left, right: right}) do
    high_left = high_node(left) + 1
    high_right = high_node(right) + 1
    {max(high_left, high_right), max(high_left, high_right)}
  end

  def hbal_tree(0), do: [nil]
  def hbal_tree(1), do: [%{value: "x", left: nil, right: nil}]

  def hbal_tree(n) when n > 1 do
    # 1
    n1 = n - 1
    # 0
    n2 = n - 2

    for {nl, nr} <- distrib(n1, n1) ++ distrib(n1, n2) ++ distrib(n2, n2),
        left <- hbal_tree(nl),
        right <- hbal_tree(nr) do
      %{value: "x", left: left, right: right}
    end
  end

  #
  # Count the leaves of a binary tree
  def count_leaves(nil), do: 0
  def count_leaves(%{value: _, left: nil, right: nil}), do: 1

  def count_leaves(%{value: _, left: left, right: right}),
    do: count_leaves(left) + count_leaves(right)

  # Collect the leaves of a binary tree in a list
  def leaves(nil, _), do: []

  def leaves(%{value: x, left: nil, right: nil}, acc),
    do: acc ++ [%{value: x, left: nil, right: nil}]

  def leaves(%{value: _, left: left, right: right}, acc) do
    leaves(left, leaves(right, acc))
  end

  def internals(nil, _), do: []
  def internals(%{value: _, left: nil, right: nil}, acc), do: acc

  def internals(%{value: x, left: nil, right: _right}, acc),
    do: acc ++ [%{value: x, left: nil, right: nil}]

  def internals(%{value: x, left: _right, right: nil}, acc),
    do: acc ++ [%{value: x, left: nil, right: nil}]

  def internals(%{value: x, left: left, right: right}, acc),
    do: internals(left, internals(right, acc)) ++ [%{value: x, left: nil, right: nil}]
end

# https://dev.to/crisefd/tree-traversal-with-elixir-lc5
# https://www.geeksforgeeks.org/applications-of-bst/
# https://www.geeksforgeeks.org/introduction-to-height-balanced-binary-tree/

# IO.inspect(Binarytrees.hbal_tree(2) |> Enum.uniq())

tree = %{
  value: 2,
  left: %{
    value: 1,
    left: %{value: 0, left: nil, right: nil},
    right: %{value: 3, left: nil, right: nil}
  },
  right: %{value: 4, left: nil, right: nil}
}

IO.inspect(Binarytrees.internals(tree, []))
