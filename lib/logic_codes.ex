defmodule Logic do
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
      IO.puts("res1ç1 #{res_1}")
      IO.puts("# res2 #{res_2}")
      oo=equal(res_1,res_2)

      oo
    else
      expr_splitted = String.split(new_expression, [" ","[","]", "(", ",", ")"], trim: true)
      keys = Map.keys(@maps_ops)
      Enum.reduce(expr_splitted, {[], false, []}, fn e, {values, current_res, opers} ->
        cond do
          (!String.contains?(e, keys) && length(opers) == 0) ->
            new_values = values ++ [e == "true"]
            {new_values, current_res, opers}

          (!String.contains?(e, keys) && length(opers) == 1) ->
            v = [e == "true"]
            op = Enum.at(opers, 0)
            latest_bool = Enum.at(values, 0)
            operator_fn = Map.fetch!(@maps_ops, op)
            new_v = operator_fn.(latest_bool, v)
            new_values = [new_v]
            new_current = new_v
            {new_values, new_current, []}


          (String.contains?(e, keys) && length(values) == 2 && length(opers) == 0) ->
            [b, a | _] = Enum.reverse(values)
            operator_fn = Map.fetch!(@maps_ops, e)
            new_v = operator_fn.(a, b)
            new_values = [new_v]
            new_current = new_v
            {new_values, new_current, []}

          true ->
            newopers = opers ++ [e]
            {values, current_res, newopers}
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

end
expression = "A and (B or C) equ A and B or A and C"
nn = Logic.map_expression([false, true , false],expression)
IO.inspect(Logic.logical_expression(nn))
