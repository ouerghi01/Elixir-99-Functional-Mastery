
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
  def node_number(nil), do: 0
  def node_number(%{left: left, right: right}) do
    node_number(left) + node_number(right) + 1
  end
  def node_number(_), do: raise("Invalid tree structure")

  # check if a tree is balanced binary tree
  def is_balanced(%{left: left, right: right}) do
    abs(node_number(left) - node_number(right)) <= 1
  end


  def cbal_tree(0), do: []
  def cbal_tree(1), do: [%{value: "x", left: nil, right: nil}]

  def cbal_tree(n) when n > 1 do
    acc = cbal_tree(n-1)
    Enum.reduce(acc,[],
    fn node,new_shit ->
      %{left: left,right: right} = node
      newfuck=if(right == nil) do
        new_right = %{value: "x" ,left: nil ,right: nil}
        final_node = Map.put(node, :right, new_right)
        if(is_balanced(final_node) and !Enum.member?(acc,final_node)) do
          new_shit ++ [final_node]
        else
          new_shit
        end
      else
        new_right = %{value: "x" ,left: nil ,right: nil}
        final_node_right = Map.put(right, :right, new_right)
        final_node = Map.put(node, :right, final_node_right)
        if(is_balanced(final_node) and !Enum.member?(new_shit,final_node)) do
          new_shit ++ [final_node]
        else
          new_shit
        end
        final_node_right_left = Map.put(right, :left, new_right)
        final_node_left = Map.put(node, :right, final_node_right_left)
        if(is_balanced(final_node_left) and !Enum.member?(new_shit,final_node_left)) do
          new_shit ++ [final_node]
        else
          new_shit
        end

      end
      new_fuck_u=if(left == nil) do
        new_left = %{value: "x" ,left: nil ,right: nil}
        final_node = Map.put(node, :left, new_left)
        if(is_balanced(final_node) and !Enum.member?(newfuck,final_node)) do
          newfuck ++ [final_node]
        else
          newfuck
        end
      else
        new_left = %{value: "x" ,left: nil ,right: nil}
        final_node_left = Map.put(left, :right, new_left)
        final_node = Map.put(node, :left, final_node_left)
        if(is_balanced(final_node) and !Enum.member?(newfuck,final_node)) do
          newfuck ++ [final_node]
        else
          newfuck
        end
        final_node_right_left = Map.put(left, :left, new_left)
        final_node_left = Map.put(node, :left, final_node_right_left)
        if(is_balanced(final_node_left) and !Enum.member?(newfuck,final_node_left)) do
          newfuck ++ [final_node]
        else
          newfuck
        end

      end
      new_fuck_u


    end)
  end
end
# prolog to elixir
defmodule BalancedBinaryTree do
  def cbal_tree(0), do: [:nil]

  def cbal_tree(n) when n > 0 do
    n0 = n - 1
    n1 = div(n0, 2)
    n2 = n0 - n1

    for {nl, nr} <- distrib(n1, n2),
        left <- cbal_tree(nl),
        right <- cbal_tree(nr) do
      {:x, left, right}
    end
  end

  defp distrib(n, n), do: [{n, n}]
  defp distrib(n1, n2), do: [{n1, n2}, {n2, n1}]
end
IO.inspect(BalancedBinaryTree.cbal_tree(2))
