
defmodule Binarytrees do
  # p54
  def is_tree(nil), do: true
  def is_tree(_), do: false
  def is_tree(tree, _acc) do
    if Map.has_key?(tree, :left) && Map.has_key?(tree, :right) do
      left = Map.get(tree,:left)
      right = Map.get(tree, :right)
      current =self()
      child= spawn(fn  ->
        send(current,{self(),
        if left != nil do
          is_tree(left, true)
        else
          true
        end
        })

      end)
      receive do
        {^child, value} ->
          new_acc = if right != nil do
            is_tree(right, value)
          else
            value
          end
          new_acc
      end
    else
      false

    end
  end
  def cbal_tree(0), do: [:nil]

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
  def symmetric(%{left: left , right: right}), do: mirror(left,right)

  defp mirror(nil, nil), do: true
  defp mirror(nil, _), do: false
  defp mirror(_, nil), do: false
  defp mirror(%{value: _,left: left ,right: right}, %{value: _,left: left1 ,right: right1}), do: mirror(left,right1) and mirror(left1,right)
  def construct([head|t], nil), do: construct(t, %{value: head, left: nil, right: nil})
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
    new_tree = cond do
      left == nil and right == nil -> construct(tail,
      %{value: head, left: %{value: min_1, left: nil, right: nil},
      right: %{value: max_1, left: nil, right: nil}})
      left == nil and right !=nil ->
        new_node =%{value: head, left: %{value: min_1 ,left: nil ,right: nil}, right: right}
        construct(tail,new_node)
      right == nil and left !=nil ->
        new_node=%{value: head, right: %{value: max_1 ,left: nil ,right: nil}, left: left}
        construct(tail,new_node)
      true ->
        new_node=%{value: head, left: left, right: right}
        construct(tail,new_node)

    end


    new_tree
  end
  #Generate-and-test paradigm
  def sym_cbal_trees(n), do: cbal_tree(n) |> Enum.filter(fn tree -> symmetric(tree) end)







end
