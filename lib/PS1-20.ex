defmodule Solutions do
  #Find the last box of a list.
  def p01(list) do
      if(length(list) == 0) do
        raise("Wait !!!")
      else Enum.at(list,-1)
      end

  end
  @spec p02(list()) :: [...]
  def p02(list) do
    if(length(list) == 2 || length(list) == 0) do
      list
    else [Enum.at(list,-2),Enum.at(list,-1)]
    end
  end
  def p03(list,n) do
    Enum.at(list,n-1)
  end
  def p04(list) do
    length(list)
  end
  def p05(list) do
    Enum.reverse(list)
  end
  #Find out whether a list is a palindrome.
  #A palindrome can be read forward or backward; e.g. (x a m a x).
  def p06(list1,list2) do
    list1|> Enum.sort() == list2|> Enum.sort()
  end
  def p07(list) do
    List.flatten(list)
  end
  def p07_v1([]), do: []
  def p07_v1([ head | tail ]) do
    p07_v1(head) ++ p07_v1(tail)
  end
  def p07_v1(head), do: [head]
  #Eliminate consecutive duplicates of list elements.
  def p08(list), do: (0..(length(list)-1))|> Enum.reduce(
    {[Enum.at(list,0)],Enum.at(list,0)},
    fn i,{acc,prev_char} ->
      current_char=Enum.at(list,i)
      if(current_char != prev_char) do
        {acc ++ [current_char],current_char}
      else
        {acc,current_char}
      end

    end
    )|>elem(0)
  # Pack consecutive duplicates of list elements into sublists.
  #If a list contains repeated elements they should be placed in separate sublists.
  def p09([]), do: []
  def p09(list) do
    if(length(list) ==1) do [list]
    else
    {head,tail,_}=(1..(length(list)-1))|> Enum.reduce(

    {[],[Enum.at(list,0)],Enum.at(list,0)},
    fn i,{acc,prev_sub,prev_char} ->
      current_char=Enum.at(list,i)
      if(current_char == prev_char) do
        {acc,[current_char|prev_sub],current_char}
      else
        {acc ++ [prev_sub],[current_char],current_char}
      end
    end)
    head ++ [tail]
  end
  end
  #Use the result of problem P09 to implement the so-called run-length encoding data
  #compression method. Consecutive duplicates of elements are encoded as lists (N E)
  #where N is the number of duplicates of the element E.
  def p10(list) do
    packed_duplicates = p09(list)
    Enum.reduce(
      packed_duplicates,[],fn ls,acc ->
        acc ++[[length(ls),Enum.at(ls,0)]]
      end
    )
  end
  # Modify the result of problem P10 in such a way that if an element has no duplicates it is simply copied into the result list. Only elements with duplicates are transferred as (N E) lists.
  def p11(list) do
    packed_duplicates = p09(list)
    Enum.reduce(
      packed_duplicates,[],fn ls,acc ->
        len=length(ls)
        if(len == 1) do
          acc ++[[Enum.at(ls,0)]]
        else
          acc ++[[length(ls),Enum.at(ls,0)]]
        end
      end
    )
  end
  #     [["a"],[2,"b"],["c"],[2,"a"],["d"],[2,"e"]] to ["a", "b", "b", "c", "a", "a", "d", "e", "e"]
  def p12(list) do
    Enum.map(list,fn l ->
      if(length(l) == 2) do
        count= Enum.at(l,0)
        char_current=Enum.at(l,1)
        Enum.reduce(0..(count-1),[],
        fn _,acc->
          acc++[char_current]
        end
        )
      else
        l
      end
    end)|> p07()
  end
  def p14(list,n) do
    Enum.reduce(list,[],fn e,acc -> #[]
        new_char=Enum.reduce(0..(n-1),[],
        fn _,acc->
          acc++[e]
          end
        )
        acc ++ new_char
    end)
  end
  # Drop every N'th element from a list.
  # Example:
  # ?- drop([a,b,c,d,e,f,g,h,i,k],3).
  #  output -> X = [a,b,d,e,g,h,k]
  def p16(list,x) do
    i=round(length(list)/x)
    Enum.reduce(1..i,{list,0},fn _,{acc,k} ->
      index=(x+k-1)
      current_drop_element=Enum.at(list,index)  #c
      new_list=Enum.filter(acc,fn e -> e != current_drop_element end)
      {new_list,k+x}
    end)|>elem(0)
  end
  # P17 (*) Split a list into two parts; the length of the first part is given.
  # Do not use any predefined predicates.
  #
  # Example:
  # ?- split([a,b,c,d,e,f,g,h,i,k],3)
  # L1 = [a,b,c]
  # L2 = [d,e,f,g,h,i,k]
  @doc """
  Splits a list into two parts at the given index `n`.

  ## Examples

    iex> PS.p17([1, 2, 3, 4, 5], 2)
    {[1, 2], [3, 4, 5]}

    iex> PS.p17_v2([1, 2, 3, 4, 5], 2)
    {[1, 2], [3, 4, 5]}

    iex> PS.p17_v1([1, 2, 3, 4, 5], 2)
    {[1, 2], [3, 4, 5]}

  ## Parameters

    - list: The list to be split.
    - n: The index at which to split the list.

  ## Returns

    - A tuple with two lists. The first list contains the elements from the start of the list up to, but not including, the index `n`. The second list contains the elements from the index `n` to the end of the list.
  """
  def p17(list,n) do
    f1=list|> Enum.slice(0,n)
    f2=list|> Enum.slice(n..length(list))
    {f1,f2}
  end
  def p17_v2(list,n) do
    Enum.split(list,n)
  end
  def p17_v1(list, n) do
    cond do
      length(list) == 0 ->
        {[], []}
      n == 0 ->
        {[],list}

      n == 1 ->
        first = hd(list)
        {[first], tl(list)}
      n > length(list) ->
        {list,[]}

      true ->
        {one, [head | tail]} = p17_v1(list, n - 1)
        {one ++ [head], tail}
    end
  end
  @doc """
  Extracts a slice from a list.

  Given two indices, `i` and `k`, this function returns a list containing the elements between the `i`th and `k`th element of the original list (both limits included). The counting of elements starts from 1.

  ## Parameters

    - `list`: The original list from which the slice will be extracted.
    - `i`: The starting index of the slice (inclusive).
    - `k`: The ending index of the slice (inclusive).

  ## Examples

      iex> slice([:a, :b, :c, :d, :e, :f, :g, :h, :i, :k], 3, 7)
      [:c, :d, :e, :f, :g]

  """
  def slice_p18(list,i,k) do
    # len = 10 , k = 7 ,dif = 3
    if (i > k) do
      []
    else
      list|>Enum.slice(i-1,k-i+1)
    end
  end
  @doc """
Examples:

  ?- rotate([a,b,c,d,e,f,g,h],3,X).
  X = [d,e,f,g,h,a,b,c]

  ?- rotate([a,b,c,d,e,f,g,h],-2,X).
  X = [g,h,a,b,c,d,e,f]

  Hint: Use the predefined predicates length/2 and append/3, as well as the result of problem P17.
"""
  def rotate_p19(list,n) do
    {one,two}=p17_v2(list,n)
    two ++ one
  end
  # (*) Remove the K'th element from a list.
  # Example:
  # ?- remove_at(X, [a, b, c, d], 2, R).
  # X = b
  # R = [a, c, d]
  def p20(list,k) do
    List.delete_at(list,k-1)
  end
  @doc """
  Inserts an element at a given position into a list.

  ## Parameters
    - element: The element to be inserted.
    - list: The list into which the element will be inserted.
    - position: The position at which the element should be inserted (1-based index).

  ## Examples

      iex> insert_at(:alfa, [:a, :b, :c, :d], 2)
      [:a, :alfa, :b, :c, :d]

  """
  def p21(element,list,pos) do
    List.insert_at(list,pos-1,element)
  end

  end
