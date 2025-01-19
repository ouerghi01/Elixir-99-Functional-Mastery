
defmodule Logic do
  def start_link do
    Agent.start_link(fn -> %{} end,name: __MODULE__)
  end
  @maps_ops %{
    "and" => &Logic.and_op/2,
    "or" => &Logic.or_op/2,
    "nand" => &Logic.nand/2,
    "nor" => &Logic.nor_op/2,
    "xor" => &Logic.xor/2,
    "equ" => &Logic.equal/2,
    "impl" => &Logic.impl/2
  }
  def and_op(a, b), do: a && b
  def nand(a, b), do: not and_op(a, b)
  def or_op(a, b), do: a || b
  def nor_op(a, b), do: not or_op(a, b)
  def xor(a, b), do: a != b
  def equal(a, b), do: a == b
  def impl(a, b), do: or_op(not a, b)

  def logical_expression(expr) do
    regex = ~r/\((.*?)\)/
    special_patterns = Regex.scan(regex, expr) |> Enum.map(fn [_, b] -> b end)
    new_expression = if length(special_patterns) != 0 do
      Enum.reduce(special_patterns, expr, fn pattern, acc_expr ->
        result = logical_expression(pattern)
        String.replace(acc_expr, "(" <> pattern <> ")", inspect(result))
      end)
    else
      expr
    end

    if(String.contains?(new_expression,"equ")) do
      expr_splitted = String.split(new_expression, [" ","[","]", "(", ",", ")"], trim: true)
      index_equ=Enum.find_index(expr_splitted,fn x -> x == "equ"  end)
      {one,[_|tail]}= expr_splitted|> Enum.split(index_equ)

      one_string = Enum.join(one, " ")
      two_string = Enum.join(tail, " ")

      res1=logical_expression(one_string)
      res2 = logical_expression(two_string)

      res_1 = if is_list(res1), do: Enum.at(res1, 0), else: res1
      res_2 = if is_list(res2), do: Enum.at(res2, 0), else: res2
      IO.puts("two_string  #{two_string}")
      IO.puts("# res2 #{res_2}")
      oo=equal(res_1,res_2)

      oo
    else
      expr_splitted = String.split(new_expression, [" ","[","]", "(", ",", ")"], trim: true)
      keys = Map.keys(@maps_ops)
      Enum.reduce(expr_splitted, {[], false, []}, fn e, {values, current_res, opers} ->
        cond do
          (!Enum.member?(keys, e) && length(opers) == 0) ->
            new_values = values ++ [e == "true"]
            {new_values, current_res, opers}

          (!Enum.member?(keys, e) && length(opers) == 1) ->
            v = e == "true"
            op = Enum.at(opers, 0)
            latest_bool = Enum.at(values, 0)
            operator_fn = Map.fetch!(@maps_ops, op)
            new_v = operator_fn.(latest_bool, v)
            new_values = [new_v]
            new_current = new_v
            {new_values, new_current, []}

          (Enum.member?(keys, e) && length(values) == 2 && length(opers) == 0) ->
            [b, a | _] = Enum.reverse(values)
            operator_fn = Map.fetch!(@maps_ops, e)
            new_v = operator_fn.(a, b)
            new_values = [new_v]
            new_current = new_v
            {new_values, new_current, []}

          Enum.member?(keys, e) ->
            newopers = opers ++ [e]
            {values, current_res, newopers}

          true ->
            {values, current_res, opers}
        end

      end)
      |> elem(1)

    end


  end

  # table(A,B,"and(A,or(A,B))").
  #  A = true,B = false ->   and(true,or(true,false))
  def map_expression(values, expr) do
    Enum.reduce_while(values, {expr, 0}, fn v, {exp, i} ->
      regex = ~r/[A-Z]/
      char_patterns = Regex.scan(regex, exp) |> List.flatten()

      if String.contains?(exp, char_patterns) do
        new_expr = if char_patterns != [] do
          String.replace(exp, to_string(Enum.at(char_patterns, rem(i, length(char_patterns)))), to_string(v))
        else
          exp
        end
        {:cont, {new_expr, i + 1}}
      else
        {:halt, {exp, i}}
      end
    end) |> elem(0)
  end
  defp generate_combinations(0), do: [[]]

  defp generate_combinations(n) do
    for tail <- generate_combinations(n - 1), value <- [true, false], do: [value | tail]
  end
  def table(n,expr) do
    combinations = generate_combinations(n)
    resultas = Enum.reduce(combinations,[], fn line ,res ->
    expr_new = map_expression(line,expr)
    resulta=logical_expression(expr_new)
    res ++ [resulta]
    end)
    for i <- 0..(2**n-1)  do
      vars= Enum.at(combinations,i) ++ [Enum.at(resultas,i)]
      IO.inspect(vars)

    end
  end


  @doc """
  Generates the n-bit Gray code sequence.

  Gray code is a binary numeral system where two successive values differ in only one bit.
  This implementation is based on the algorithm described in Problem 49.

  ## Parameters
    - n: The number of bits in the Gray code sequence.

  ## Examples

      iex> LogicCodes.gray(1)
      [0, 1]

      iex> LogicCodes.gray(2)
      ["00", "01", "11", "10"]

      iex> LogicCodes.gray(3)
      ["000", "001", "011", "010", "110", "111", "101", "100"]

  """
  #https://www.geeksforgeeks.org/generate-n-bit-gray-codes/
  # https://stackoverflow.com/questions/69163081/how-can-values-be-cached-in-an-elixir-function#:~:text=Short%20answer%20is%20-%20you%20can%27t.%20Functional%20means,is%20to%20wrap%20that%20state%20in%20a%20process.
  def gray(1) do
    [0,1]
  end
  def gray(n) do
     # Check if the result is already cached
    case Agent.get(__MODULE__,&Map.get(&1,n)) do
      nil ->
        previous_gray = gray(n - 1)
        reversed_gray = Enum.reverse(previous_gray)
        {first_half, second_half} = Enum.reduce(0..(length(previous_gray) - 1), {[], []},
          fn index, {acc1, acc2} ->
            original = Enum.at(previous_gray, index)
            reversed = Enum.at(reversed_gray, index)
            new_original = "0#{original}"
            new_reversed = "1#{reversed}"
            {acc1 ++ [new_original], acc2 ++ [new_reversed]}
          end)

        result= first_half ++ second_half
        Agent.update(__MODULE__, &Map.put(&1, n, result))
        result
      cached_result ->
        cached_result
    end

  end
  # list = [%{char:a,value:5},{b,9},..]
  def buildTree(list) do
    new_list = Enum.sort_by(list,&(&1.value))
    Enum.reduce_while(new_list, new_list, fn _, acc ->
      if length(acc) == 1 do
        {:halt, acc}
      else
        [first_node, second_node | rest] = acc
        new_node = %{
          value: Map.get(first_node, :value) + Map.get(second_node, :value),
          left: %{
            byte: 0,
            node: first_node
          },
          right: %{byte: 1 ,node: second_node}
        }
        nn_list = rest ++ [new_node]
        nn = Enum.sort_by(nn_list,&(&1.value))
        {:cont,nn}
      end
    end) |> Enum.at(0)
  end


  def huffman(root, val,acc = []) do
    v_byte = Map.get(root, :byte, "")
    new_val = "#{val}#{v_byte}"
    node = Map.get(root, :node)
      if (Map.get(node, :left) != nil) do
        huffman(Map.get(node, :left), new_val, acc)
      end
      if (Map.get(node, :right) != nil) do
        huffman(Map.get(node, :right), new_val, acc)
      end
      if( Map.get(node, :right) == nil and Map.get(node, :left) == nil) do
        IO.puts("#{Map.get(node, :char)} -> #{new_val}")
        acc ++ %{
          char: Map.get(node, :char),
          byte_val: new_val
        }
      end
  end


end
# {:ok, _pid} = Logic.start_link()
# list = [%{char: "a", value: 45}, %{char: "b", value: 13}, %{char: "c", value: 12}, %{char: "d", value: 16}, %{char: "e", value: 9}, %{char: "f", value: 5}]
# tree = Logic.buildTree(list)
# left_tree = Map.get(tree, :left)
# right_tree = Map.get(tree, :right)

# Logic.huffman_printer(left_tree, "")
# Logic.huffman_printer(right_tree, "")
